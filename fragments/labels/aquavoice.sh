aquavoice)
    name="Aqua Voice"
    type="zip"
    expectedTeamID="6PX97UJ486"
    versionKey="CFBundleShortVersionString"

    # Follow the fully rolled out stable release, not the staged release.
    aquaBaseURL="https://updates.aquavoice.com/stable/darwin"
    appNewVersion=$(/usr/bin/curl -fsSL --connect-timeout 10 --max-time 30 \
        -H 'Cache-Control: no-cache' "${aquaBaseURL}/rollout.json?ts=$(/bin/date +%s)" | \
        /usr/bin/plutil -extract full_rollout_version raw -o - - 2>/dev/null)
    if [[ ! "$appNewVersion" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        cleanupAndExit 14 "Aqua Voice: no valid full_rollout_version" ERROR
    fi

    aquaManifest=$(/usr/bin/curl -fsSL --connect-timeout 10 --max-time 30 \
        "${aquaBaseURL}/versions/${appNewVersion}/RELEASES.json")
    aquaFeedVersion=$(printf '%s' "$aquaManifest" | \
        /usr/bin/plutil -extract currentRelease raw -o - - 2>/dev/null)
    aquaPackageVersion=$(printf '%s' "$aquaManifest" | \
        /usr/bin/plutil -extract releases.0.updateTo.version raw -o - - 2>/dev/null)
    downloadURL=$(printf '%s' "$aquaManifest" | \
        /usr/bin/plutil -extract releases.0.updateTo.url raw -o - - 2>/dev/null)
    if [[ "$aquaFeedVersion" != "$appNewVersion" || \
          "$aquaPackageVersion" != "$appNewVersion" || \
          "$downloadURL" != "${aquaBaseURL}/Aqua%20Voice-darwin-${appNewVersion}.zip" ]]; then
        cleanupAndExit 14 "Aqua Voice: inconsistent release manifest" ERROR
    fi

    # Installomator compares versions for equality; preserve newer local builds.
    aquaInstalledPlist="${targetDir:-/Applications}/Aqua Voice.app/Contents/Info.plist"
    aquaInstalledVersion=$(/usr/libexec/PlistBuddy \
        -c "Print ${versionKey}" "$aquaInstalledPlist" 2>/dev/null)
    autoload -Uz is-at-least
    if [[ "$aquaInstalledVersion" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ && \
          "$aquaInstalledVersion" != "$appNewVersion" && "${INSTALL:-}" != "force" ]] && \
          is-at-least "$appNewVersion" "$aquaInstalledVersion"; then
        cleanupAndExit 0 "Aqua Voice: keeping newer installed version ${aquaInstalledVersion}" INFO
    fi
    ;;
