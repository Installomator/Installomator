codex)
    name="Codex"
    type="zip"
    appName="ChatGPT.app"
    targetDir="/Applications/ChatGPT.localized"
    if [[ $(arch) == "arm64" ]]; then
        sparkleData=$(curl -fsL "https://persistent.oaistatic.com/codex-app-prod/appcast.xml")
        appNewVersion=$(echo "$sparkleData" | awk -F "[<>]" '/<sparkle:shortVersionString>/{print $3; exit}')
        downloadURL=$(echo "$sparkleData" | awk -F 'url="' '/<enclosure url=/{split($2,a,"\""); print a[1]; exit}')
    else
        printlog "Codex is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "Codex requires Apple Silicon" ERROR
    fi
    expectedTeamID="2DC432GLL2"
    blockingProcesses=( "ChatGPT" )
    ;;
