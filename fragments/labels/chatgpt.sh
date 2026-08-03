chatgpt|\
chatgptclassic)
    name="ChatGPT Classic"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://persistent.oaistatic.com/classic/public/ChatGPT_Classic.dmg"
    else
        cleanupandexit 2 "No Intel-compatible download URL found. $appLabel is not Intel-compatible. Could not install app." ERROR
    fi
    appNewVersion="$(curl -fs "https://persistent.oaistatic.com/sidekick/public/sparkle_public_appcast.xml" | xpath '(//rss/channel/item/title)[1]/text()' 2>/dev/null)"
    expectedTeamID="2DC432GLL2"
    ;;
