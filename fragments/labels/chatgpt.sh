chatgpt)
    name="ChatGPT"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://persistent.oaistatic.com/sidekick/public/ChatGPT_Desktop_public_latest.dmg"
    else
        cleanupandexit 2 "No Intel-compatible download URL found. $appLabel is not Intel-compatible. Could not install app." ERROR
    fi
    appNewVersion="$(curl -fs "https://persistent.oaistatic.com/sidekick/public/sparkle_public_appcast.xml" | xpath '(//rss/channel/item/title)[1]/text()' 2>/dev/null)"
    expectedTeamID="2DC432GLL2"
    ;;
