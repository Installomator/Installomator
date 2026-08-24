chatgptclassic)
    name="ChatGPT Classic"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://persistent.oaistatic.com/sidekick/public/ChatGPT_Classic.pkg"
    else
        printlog "ChatGPT Classic is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "ChatGPT Classic requires Apple Silicon" ERROR
    fi
    appNewVersion=$(curl -fs "https://persistent.oaistatic.com/sidekick/public/sparkle_public_appcast.xml" | xpath 'string((//rss/channel/item/title)[1])' 2>/dev/null)
    expectedTeamID="2DC432GLL2"
    ;;
