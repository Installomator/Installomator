#!/bin/bash
# lint_label.sh — static checks for Installomator label files (fragments/labels/*.sh)
#
# Usage: utils/lint_label.sh [-q] [-g] file.sh [file.sh ...]
#   -q   quiet: only print ERROR lines and the summary
#   -g   GitHub Actions: print findings as workflow annotations
#        (::error / ::warning / ::notice) and require zsh for the syntax check
#
# Checks .editorconfig formatting (LF, final newline, no trailing whitespace,
# 4-space indent, no tabs), label structure, required variables, and
# commands/flags that are unavailable or unreliable on older supported macOS.
# Exit status: 0 = no errors, 1 = at least one ERROR, 2 = usage.
#
# Levels: ERROR fails the check; WARN and INFO are reported for review.
# Each message ends with a rule name in brackets, e.g. [awk-ignorecase].
# The rules are explained at
# https://github.com/Installomator/Installomator/wiki/Label-Lint-Rules
#
# Written for bash 3.2 (macOS /bin/bash) and BSD/GNU awk alike. Set AWK to
# choose the awk binary (default: awk).

AWK=${AWK:-awk}
quiet=0
github=0
while [ $# -gt 0 ]; do
    case "$1" in
        -q) quiet=1; shift ;;
        -g) github=1; shift ;;
        --) shift; break ;;
        -*) echo "usage: $0 [-q] [-g] label.sh [label.sh ...]" >&2; exit 2 ;;
        *) break ;;
    esac
done
if [ $# -eq 0 ]; then
    echo "usage: $0 [-q] [-g] label.sh [label.sh ...]" >&2
    exit 2
fi

have_zsh=0
if command -v zsh >/dev/null 2>&1; then have_zsh=1; fi
if [ $github -eq 1 ] && [ $have_zsh -eq 0 ]; then
    echo "::error title=lint_label.sh::zsh is required for the label syntax check"
    exit 2
fi

# Print findings ("file:line: LEVEL: message") in the selected output mode.
emit() {
    if [ $github -eq 1 ]; then
        "$AWK" '{
            if (!match($0, /:[0-9]+: (ERROR|WARN|INFO): /)) { print; next }
            file = substr($0, 1, RSTART - 1)
            rest = substr($0, RSTART + 1)
            n = index(rest, ":"); ln = substr(rest, 1, n - 1); rest = substr(rest, n + 2)
            n = index(rest, ":"); lvl = substr(rest, 1, n - 1); msg = substr(rest, n + 2)
            cmd = "notice"
            if (lvl == "ERROR") cmd = "error"
            else if (lvl == "WARN") cmd = "warning"
            gsub(/%/, "%25", msg); gsub(/\r/, "%0D", msg)
            gsub(/%/, "%25", file); gsub(/\r/, "%0D", file); gsub(/:/, "%3A", file); gsub(/,/, "%2C", file)
            loc = "file=" file
            if (ln + 0 > 0) loc = loc ",line=" ln
            printf "::%s %s,title=lint_label %s::%s\n", cmd, loc, lvl, msg
        }'
    elif [ $quiet -eq 1 ]; then
        grep ': ERROR: '
    else
        cat
    fi
}

total_errors=0
total_warns=0
files=0

for f in "$@"; do
    files=$((files + 1))
    if [ ! -f "$f" ]; then
        printf '%s:0: ERROR: file not found\n' "$f" | emit
        total_errors=$((total_errors + 1))
        continue
    fi

    out=$("$AWK" -v FILE="$f" -v SQ="'" '
    function report(level, ln, msg) {
        printf "%s:%d: %s: %s\n", FILE, ln, level, msg
        if (level == "ERROR") errs++
        else if (level == "WARN") warns++
    }
    function strip_comment(s,   i, c, q) {
        # crude: drop text after a # that is preceded by whitespace and not inside quotes
        q = ""
        for (i = 1; i <= length(s); i++) {
            c = substr(s, i, 1)
            if (q == "" && (c == "\"" || c == SQ)) q = c
            else if (q != "" && c == q) q = ""
            else if (q == "" && c == "#" && (i == 1 || substr(s, i-1, 1) ~ /[ \t]/)) return substr(s, 1, i-1)
        }
        return s
    }
    BEGIN {
        errs = 0; warns = 0; in_header = 1; header_done = 0; label = ""
        valid_types = " dmg pkg zip tbz bz2 pkgInDmg pkgInZip appInDmgInZip pkgInDmgInZip updateronly "
        appless_types = " dmg zip tbz bz2 appInDmgInZip "
        git_line = 0; archive_after_git = 0
    }
    {
        raw = $0
        lines[NR] = raw
        if (raw ~ /\r/) { report("ERROR", NR, "Windows (CRLF) line ending; save the file with Unix (LF) line endings [crlf]"); sub(/\r$/, "", raw) }
        if (raw ~ /\t/) report("ERROR", NR, "tab character; indent with spaces, 4 per level [tab]")
        if (raw ~ /[ \t]+$/) report("ERROR", NR, "spaces or tabs at the end of the line; remove them [trailing-whitespace]")

        if (NR == 1 && raw ~ /^#!/) { report("ERROR", NR, "remove the #! line; a label is a case branch inside Installomator.sh, not a standalone script [shebang]"); next }

        # ---- header (label name lines) ----
        if (in_header) {
            if (raw ~ /^[a-z0-9_-]+\|\\$/ || raw ~ /^[a-z0-9_-]+\)$/) {
                nm = raw; sub(/(\|\\|\))$/, "", nm)
                if (label == "") label = nm
                names = names " " nm
                if (raw ~ /\)$/) { in_header = 0; header_done = 1 }
                next
            } else if (raw ~ /^[^ \t#].*(\\|\))$/) {
                # header line that zsh may accept but does not follow the convention
                nm = raw; sub(/[ ]*(\|[ ]*\\|\))$/, "", nm)
                if (nm ~ /^[A-Za-z0-9_.-]+$/ && nm !~ /^[a-z0-9_-]+$/)
                    report("ERROR", NR, "label name must use only lowercase letters a-z, digits 0-9, - and _ (got: " nm ") [label-name]")
                else
                    report("ERROR", NR, "header line \"" raw "\" must be name) on the last header line, or name|\\ on each alias line above it, with no spaces [header-format]")
                if (label == "" && nm ~ /^[A-Za-z0-9_.-]+$/) label = nm
                if (nm ~ /^[A-Za-z0-9_.-]+$/) names = names " " nm
                if (raw ~ /\)$/) { in_header = 0; header_done = 1 }
                next
            } else {
                report("ERROR", NR, "the first line must be the label name followed by ) with no indentation; put any aliases on lines above it as name|\\ [header-format]")
                in_header = 0; header_done = 1
                # fall through and treat as body
            }
        }

        # ---- body ----
        if (raw ~ /^[ \t]*$/) { blank_run++; next }
        blank_run = 0
        lastln = NR; last = raw

        match(raw, /^ */); ind = RLENGTH
        if (raw !~ /^\t/ && raw !~ /^[ ]*;;[ ]*$/) {
            if (ind == 0) report("ERROR", NR, "line is not indented; indent every line of the label body by 4 spaces [indent]")
            else if (ind % 4 != 0) report("WARN", NR, "indented by " ind " spaces; use a multiple of 4 spaces [indent]")
        }

        trimmed = raw; sub(/^[ \t]+/, "", trimmed)
        is_comment = (trimmed ~ /^#/)

        if (is_comment) {
            if (trimmed ~ /^#[ ]*(downloadURL|appNewVersion|name|type|expectedTeamID|archiveName|appName)=/)
                report("WARN", NR, "commented-out assignment; remove unused code [comments]")
            else if (tolower(trimmed) ~ /credit|contributed by|thanks to|^# *(by|author) /)
                report("WARN", NR, "credit/author comment; per CONTRIBUTING.md, credit lines are not kept in labels [comments]")
            else
                report("WARN", NR, "comment line; labels do not carry comments, to keep Installomator.sh short [comments]")
            next
        }

        code = strip_comment(trimmed)
        if (code != trimmed)
            report("WARN", NR, "comment at the end of the line; labels do not carry comments, to keep Installomator.sh short [comments]")

        # assignments
        if (match(code, /^[A-Za-z_][A-Za-z0-9_]*(\+)?=/)) {
            var = substr(code, 1, RLENGTH - 1); sub(/\+$/, "", var)
            val = substr(code, RLENGTH + 1)
            seen[var] = NR
            if (raw ~ /\\$/) {
                if (var ~ /^(name|type|downloadURL|appNewVersion|expectedTeamID|archiveName|appName|packageID)$/)
                    report("ERROR", NR, var "= continues onto the next line with \\; put the whole assignment on one line [multiline-assignment]")
                else
                    report("WARN", NR, "assignment continues onto the next line with \\; keep each assignment on one line [multiline-assignment]")
            }
            if (var == "type") {
                t = val; gsub(/"/, "", t); gsub(SQ, "", t)
                types[NR] = t
                if (index(valid_types, " " t " ") == 0 && t !~ /^\$/)
                    report("ERROR", NR, "type=\"" t "\" is not a valid type; use one of dmg pkg zip tbz bz2 pkgInDmg pkgInZip appInDmgInZip pkgInDmgInZip updateronly (case-sensitive) [type]")
                last_type = t
            }
            if (var == "expectedTeamID") {
                tid = val; gsub(/"/, "", tid); gsub(SQ, "", tid)
                if (tid == "Software Update")
                    report("INFO", NR, "expectedTeamID \"Software Update\" is only correct for pkgs signed by Apple; check with spctl -a -vv -t install [team-id]")
                else if (tid !~ /^\$/ && tid !~ /^[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]$/)
                    report("WARN", NR, "expectedTeamID \"" tid "\" is not a 10-character Team ID; check the signature with spctl -a -vv (app) or spctl -a -vv -t install (pkg) and use the ID in parentheses. Only older certificates without one use another value [team-id]")
                if (val !~ ("^[\"" SQ "]"))
                    report("WARN", NR, "put the Team ID in double quotes: expectedTeamID=\"" tid "\" [team-id]")
            }
            if (var ~ /^(blockingProcesses|curlOptions)$/ && val !~ /^\(/)
                report("WARN", NR, var " must be an array: " var "=( \"item\" ... ) [array]")
            if (var ~ /^(updateToolArguments|CLIArguments)$/ && val !~ /^\(/)
                report("INFO", NR, var " is usually an array: " var "=( ... ) [array]")
            if (var == "archiveName" && git_line > 0) archive_after_git = NR
            if (var == "downloadURL" && val ~ /^"?http:\/\//)
                report("WARN", NR, "downloadURL uses http://; use https:// if the vendor offers it [https]")
        }
        if (code ~ /^(appCustomVersion|function appCustomVersion)/) {
            seen["appCustomVersion"] = NR
            if (code !~ /\}[ ]*$/) report("WARN", NR, "write appCustomVersion as a one-line function: appCustomVersion(){ ... } [appcustomversion]")
        }

        if (code ~ /downloadURLFromGit/ && git_line == 0) git_line = NR
        # arm64-only if-blocks: need an else/elif unless downloadURL is also set outside the block
        if (code ~ /^if .*arch\)"?[ ]*==[ ]*"?arm64/ && code !~ /[; ]fi[ ;]*$/ && arm_line == 0) { arm_line = NR; in_arm = 1; arm_depth = 0 }
        else if (in_arm && code ~ /^if[ ]/) arm_depth++
        else if (in_arm && arm_depth == 0 && code ~ /^(else|elif)([ ;]|$)/) { arm_other = 1; in_arm = 0 }
        else if (in_arm && code ~ /^fi([ ;]|$)/) { if (arm_depth == 0) in_arm = 0; else arm_depth-- }
        else if (!in_arm && code ~ /^downloadURL=/) url_outside = 1

        # ---- commands / compatibility ----
        # cmd: code with single-quoted text (awk/sed programs, literals) blanked out,
        # used for checks that look for a command name in command position.
        cmd = code; gsub(SQ "[^" SQ "]*" SQ, SQ SQ, cmd)
        CP = "(^|[|;&(]|\\$\\(|then|do|else)[ ]*(/usr/bin/|/usr/local/bin/|/opt/homebrew/bin/)?"
        if (cmd ~ (CP "jq([ ]|$)"))
            report("ERROR", NR, "jq is only available on macOS 15 and later; use getJSONValue \"$json\" \"key.path\" instead [jq]")
        if (cmd ~ (CP "python[0-9.]*([ ]|$)"))
            report("ERROR", NR, "python was removed from macOS in 12.3; use getJSONValue, xpath or sed instead [python]")
        if (cmd ~ (CP "(perl|ruby)[ ]+-"))
            report("WARN", NR, "perl and ruby are deprecated in macOS and may be removed; use sed -E, awk or zsh instead [perl-ruby]")
        if (code ~ /\/usr\/bin\/xpath/)
            report("WARN", NR, "call xpath (the Installomator wrapper function), not /usr/bin/xpath; the wrapper handles the argument change in macOS 11 [xpath]")
        if (code ~ /(^|[ |;(])xpath[ ]+-e/)
            report("ERROR", NR, "xpath -e fails on macOS 10.15 and earlier; call xpath without -e and the Installomator wrapper adds it when needed [xpath]")
        if (code ~ /grep[ ]+(-[A-Za-z]*P|--perl)/)
            report("ERROR", NR, "grep -P does not exist in macOS grep; use grep -E or sed -E [grep-p]")
        if (code ~ /sed[ ]+(-[A-Za-z]*r|--regexp-extended)/)
            report("WARN", NR, "use sed -E instead of sed -r; -E is the form every macOS version supports [sed-r]")
        if (code ~ /sed[ ]+(-[A-Za-z]*i)/)
            report("WARN", NR, "sed -i edits files in place and works differently on macOS and Linux; labels should not need it [sed-i]")
        if (code ~ /plutil[^|]*-extract[^|]*[ ]raw/)
            report("ERROR", NR, "plutil -extract ... raw requires macOS 12 or later; use getJSONValue for JSON, or defaults read / PlistBuddy for plists [plutil-raw]")
        if (cmd ~ (CP "readlink[ ]+-[A-Za-z]*f") || cmd ~ (CP "realpath([ ]|$)"))
            report("ERROR", NR, "readlink -f and realpath are missing on older macOS; use the zsh :A modifier, e.g. ${path:A} [readlink]")
        if (cmd ~ (CP "date[ ]+(-[A-Za-z]*d|--date)"))
            report("ERROR", NR, "date -d only exists on Linux; on macOS use date -j -f <input format> <string> +<output format> [date-d]")
        if (code ~ /head[ ]+-n[ ]*-[0-9]/ || code ~ /head[ ]+--lines=-/)
            report("ERROR", NR, "head -n with a negative count only works on Linux; to drop the last line use sed " SQ "$d" SQ " [head-negative]")
        if (cmd ~ (CP "tac([ ]|$)"))
            report("ERROR", NR, "tac does not exist on macOS; use tail -r to reverse lines [tac]")
        if (code ~ /IGNORECASE/)
            report("ERROR", NR, "IGNORECASE is ignored by macOS awk, so the match stays case-sensitive; compare with tolower(), e.g. tolower($1)==\"location:\" [awk-ignorecase]")
        if (code ~ /gensub[ ]*\(/)
            report("ERROR", NR, "gensub() does not exist in macOS awk; use sub()/gsub() or sed -E [awk-gensub]")
        if (code ~ /--fail-with-body|--retry-all-errors|--no-progress-meter|%\{json\}/)
            report("ERROR", NR, "this curl option is newer than the curl in macOS 10.14 (7.54); remove it or use an older equivalent [curl-option]")
        if (code ~ /base64[ ]+(-d|--decode)/)
            report("WARN", NR, "base64 -d is not accepted on older macOS; use base64 -D [base64]")
        if (code ~ /uname[ ]+-m/)
            report("INFO", NR, "to check the architecture, use [[ $(arch) == \"arm64\" ]] ... elif [[ $(arch) == \"i386\" ]] like other labels [arch]")
        if (code ~ /api\.github\.com\/repos\/[^\/]+\/[^\/]+\/releases\/latest/)
            report("INFO", NR, "consider downloadURLFromGit / versionFromGit instead of calling the GitHub API directly [github-api]")
        if (cmd ~ (CP "exit([ ;]|$)") && code !~ /(^|[^a-z])awk[ ]/)
            report("ERROR", NR, "do not call exit in a label; use cleanupAndExit <code> \"message\" ERROR so Installomator can clean up [exit]")
        if (cmd ~ (CP "(eval|source)[ ]"))
            report("ERROR", NR, "do not use eval or source in a label; never run text downloaded from a vendor as code [eval]")
        if (cmd ~ (CP "local[ ]") && cmd !~ /appCustomVersion/)
            report("WARN", NR, "local only works inside a function; remove local here [local]")
        if (code ~ /(^|[ |;(])curl[ ]/ && code !~ /curl[^|]*(-[A-Za-z]*f[A-Za-z]*|--fail)([ ]|$)/)
            report("INFO", NR, "curl without -f/--fail treats an HTTP error page as content; add -f, e.g. curl -fsL [curl-fail]")
    }
    END {
        if (lastln == 0) { report("ERROR", 1, "file has no label body [label-body]"); print "##", errs, warns, label names; exit }
        if (last != "    ;;")
            report("ERROR", lastln, "the last line must be exactly four spaces followed by ;; (got: \"" last "\") [label-end]")
        if (blank_run > 0)
            report("WARN", NR, "blank line(s) after ;; - the file should end right after ;; and its newline [label-end]")
        split("name type downloadURL expectedTeamID", req, " ")
        for (i = 1; i <= 4; i++) if (!(req[i] in seen)) report("ERROR", 1, "required variable " req[i] " is not set [required]")
        if (!("appNewVersion" in seen)) report("WARN", 1, "appNewVersion is not set; maintainers expect it, or a reason in the PR why the version cannot be determined [appnewversion]")
        if (("packageID" in seen) && index(appless_types, " " last_type " ") > 0)
            report("WARN", seen["packageID"], "packageID is set on a type=\"" last_type "\" label; it is only needed for pkg installs that do not place an app in /Applications [packageid]")
        if (arm_line > 0 && !arm_other && !url_outside)
            report("ERROR", arm_line, "the arm64 branch has no else/elif, so Intel Macs are not handled; add an elif [[ $(arch) == \"i386\" ]] branch, or for Apple-Silicon-only apps: else cleanupAndExit 95 \"<App> requires Apple Silicon\" ERROR [arch]")
        if (archive_after_git)
            report("WARN", archive_after_git, "archiveName must be set before downloadURLFromGit, which uses it to pick the release file [archivename]")
        print "##", errs, warns, label names
    }
    ' "$f")

    summary=$(printf '%s\n' "$out" | tail -1)
    body=$(printf '%s\n' "$out" | sed '$d')
    read -r _ ferrs fwarns flabel fnames <<EOF
$summary
EOF
    ferrs=${ferrs:-1}; fwarns=${fwarns:-0}

    # final newline (awk cannot see this)
    if [ -s "$f" ] && [ -n "$(tail -c 1 "$f")" ]; then
        body="${body:+$body
}$f:0: ERROR: missing newline at the end of the file [final-newline]"
        ferrs=$((ferrs + 1))
    fi

    # file name should match one of the label names in the header
    base=$(basename "$f" .sh)
    case " $fnames " in
        *" $base "*) ;;
        *)
            if [ -n "$flabel" ] && [ "$base" != "$(basename "$f")" ]; then
                body="${body:+$body
}$f:1: WARN: file name \"$base.sh\" does not match any label name in its header; rename it to fragments/labels/$flabel.sh [file-name]"
                fwarns=$((fwarns + 1))
            fi
            ;;
    esac

    # zsh syntax check, when zsh is available
    if [ $have_zsh -eq 1 ]; then
        synerr=$( { printf 'case $label in\n'; cat "$f"; printf 'esac\n'; } | zsh -n 2>&1 )
        if [ -n "$synerr" ]; then
            body="${body:+$body
}$f:0: ERROR: zsh syntax check failed: $(printf '%s' "$synerr" | head -3 | tr '\n' ' ')[syntax]"
            ferrs=$((ferrs + 1))
        fi
    fi

    if [ -n "$body" ]; then
        printf '%s\n' "$body" | emit
    fi
    total_errors=$((total_errors + ferrs))
    total_warns=$((total_warns + fwarns))
done

echo "-- $files file(s): $total_errors error(s), $total_warns warning(s)"
[ $total_errors -eq 0 ]
