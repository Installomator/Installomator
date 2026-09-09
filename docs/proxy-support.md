# Proxy support

Installomator can download through an HTTP proxy, including one that requires
authentication. Configuration is read from the environment.

This replaces the earlier `PROXY` variable, which has been removed. See
[Migrating from PROXY](#migrating-from-proxy) below.

## Configuration

Set these in the environment of the Installomator process. All are optional; with
`PROXY_HOST` unset there is no proxy handling at all.

| Variable | Required | Description |
|---|---|---|
| `PROXY_HOST` | to enable | Hostname or IP. No scheme, no credentials. A value containing `://` or `@` is rejected. |
| `PROXY_PORT` | no | Port. Defaults to `3128`. |
| `PROXY_USER` | no | Username, raw and unencoded. |
| `PROXY_PASS` | no | Password, raw and unencoded. The script percent-encodes it. |
| `PROXY_FALLBACK_DIRECT` | no | `yes` permits a direct download when the proxy is unusable. Anything else, including unset, fails closed. |
| `PROXY_PROBE_HOST` | no | Host used for the `CONNECT` probe. Defaults to `github.com`. |

```bash
sudo PROXY_HOST=192.0.2.10 \
     PROXY_PORT=3128 \
     PROXY_USER=svc-installomator \
     PROXY_PASS='Testpass123' \
     ./Installomator.sh desktoppr
```

### Why the environment and not arguments

Installomator evaluates any `key=value` argument and then logs the full argument list.
A password passed as an argument is therefore written to
`/private/var/log/Installomator.log` — which is readable by any admin user on the
device — before the proxy has even been validated. Arguments are also visible in
process listings. Environment variables of a root-owned process are not readable by
other users on macOS.

### Passwords with special characters

Credentials are supplied raw and encoded by the script. A caller cannot distinguish an
already-encoded value from a literal one containing `%`, so the script owns the
encoding.

Passwords containing `@ : / # ?` work. This matters in practice: `#` truncates a URL,
so an unencoded `P@ss:w/rd#1` produces no connection at all, while the encoded
`P%40ss%3Aw%2Frd%231` authenticates.

Encoding is ASCII-only. Multi-byte characters in credentials are not supported.

## Exit codes

| Code | Meaning | Cause |
|---|---|---|
| `80` | Proxy unreachable | Connection timed out |
| `81` | Proxy refused | Connection actively refused |
| `82` | Proxy auth failed | `407` returned to `CONNECT` |
| `83` | Proxy tunnel denied | Non-200, non-407 to `CONNECT`, e.g. `403` from a destination allowlist |
| `84` | Proxy misconfigured | Proxy hostname unresolvable, or `PROXY_HOST` contains a scheme or credentials |

These are distinct so a caller can map a failure reason without parsing log text.

## Behaviour

**Validation uses a real `CONNECT`.** The probe issues a `CONNECT` through the proxy to
`PROXY_PROBE_HOST` using `curl`, which is already a hard dependency. A bare TCP port
check is not sufficient — it proves only that the port accepts a connection, so a proxy
requiring authentication passes even with no credentials supplied, and the `407` then
surfaces later as a failed download rather than as a proxy fault.

**Validation runs before label resolution.** Labels resolve their download URLs over the
network. If the proxy is broken, that resolution silently produces an empty result and
`downloadURL` collapses, so the error reads as a broken label. Validating first keeps
the two causes distinguishable.

**Failure is closed by default.** Falling back to a direct download when a proxy was
explicitly configured hides a broken proxy and defeats the reason for configuring one.
Set `PROXY_FALLBACK_DIRECT=yes` to opt in; the fallback is logged when it happens.

**Only the redacted proxy URL is logged.** `PROXY_PASS` and the assembled proxy URL are
never passed to `printlog`.

**Only curl reads `ALL_PROXY`.** On success the script exports it. Anything a label
shells out to — `softwareupdate`, for example — bypasses the proxy.

## Calling from a daemon or MDM

Build the child environment explicitly rather than inheriting and adding to it. Clear
all of `ALL_PROXY`, `all_proxy`, `http_proxy`, `https_proxy`, `HTTPS_PROXY`, `no_proxy`,
`NO_PROXY` before setting `PROXY_*`.

Two reasons. Scheme-specific variables take precedence over `ALL_PROXY` in curl, so an
inherited `https_proxy` would silently override the proxy this script sets for every
download — all of which are HTTPS. And with no proxy configured, an inherited
`ALL_PROXY` would route downloads through a proxy the caller never configured while
reporting them as direct.

A LaunchDaemon does not source shell profiles, so `/etc/profile` and user dotfiles are
not a concern. `launchctl setenv` is.

## Migrating from PROXY

`PROXY="host:port"` becomes `PROXY_HOST=host` and `PROXY_PORT=port`, moved from the
script or arguments into the environment.

The old variable was removed rather than kept as an alias. It could not express
credentials — `cut -d ":"` split on the first colon, so `user:pass@host:3128` parsed
the address as `user` and the port as `pass@host` — and when its reachability check
failed it logged an error and downloaded directly while returning exit code `0`, so
callers recorded a successful install through a proxy that was never contacted.

## Testing

A local Squid with basic auth is enough to cover the behaviour:

| # | Setup | Expected |
|---|---|---|
| 1 | No `PROXY_*` set | Downloads direct, exit 0 |
| 2 | Valid host, port, user, pass | Downloads through proxy, exit 0. `access.log` shows `TCP_TUNNEL/200 ... CONNECT` with the username |
| 3 | No credentials, proxy requires auth | Exit 82, no download attempted |
| 4 | Wrong password | Exit 82 |
| 5 | Closed port | Exit 80 or 81 |
| 6 | Nonexistent hostname | Exit 84 |
| 7 | `PROXY_HOST=http://proxy.example.com` | Exit 84, rejected before any network call |
| 8 | Password containing `@ : / # ?` | Downloads through proxy, exit 0 |
| 9 | Unreachable proxy, `PROXY_FALLBACK_DIRECT=yes` | Downloads direct, exit 0, fallback logged |
| 10 | Any failing case above | Password does not appear in `/private/var/log/Installomator.log` |

Test 8 is the one most likely to be skipped and most likely to matter — enterprise proxy
passwords routinely contain those characters. Test 10 guards the credential-logging
regression.

## Maintenance

The implementation is confined to three regions, and should stay that way:

- `fragments/header.sh` — the documentation comment
- `fragments/functions.sh` — `urlEncode`, `proxyProbe`, `setupProxy`
- `fragments/arguments.sh` — the single `setupProxy` call

Do not scatter proxy handling into label definitions or the download routine. Labels are
where churn concentrates, and a diff that reaches into them conflicts with everything.

Edit the fragments, not `Installomator.sh`. The script at the repository root is
generated and direct edits to it are lost on the next build:

```bash
./assemble.sh --script
```
