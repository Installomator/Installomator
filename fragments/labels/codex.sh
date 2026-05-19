codex)
    name="Codex"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://persistent.oaistatic.com/codex-app-prod/Codex.dmg"
    elif typeset -f cleanupAndExit >/dev/null 2>&1; then
        printlog "Codex is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 1 "Codex requires Apple Silicon" ERROR
    else
        downloadURL="https://persistent.oaistatic.com/codex-app-prod/Codex.dmg"
    fi
    appNewVersion="$(curl -fs "https://persistent.oaistatic.com/codex-app-prod/appcast.xml" | grep -o '<sparkle:shortVersionString>[^<]*' | head -1 | cut -d '>' -f 2)"
    expectedTeamID="2DC432GLL2"
    ;;
