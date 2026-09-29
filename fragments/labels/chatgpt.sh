chatgpt|codex)
    name="ChatGPT"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
        sparkleData=$(curl -fsL "https://persistent.oaistatic.com/codex-app-prod/appcast.xml")
        appNewVersion=$(echo "$sparkleData" | xpath 'string(//rss/channel/item[1]/sparkle:shortVersionString)')
        downloadURL=$(echo "$sparkleData" | xpath 'string(//rss/channel/item[1]/enclosure/@url)')
    else
        printlog "ChatGPT is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "ChatGPT requires Apple Silicon" ERROR
    fi
    blockingProcesses=( "ChatGPT" )
    expectedTeamID="2DC432GLL2"
    ;;
