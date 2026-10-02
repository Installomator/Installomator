awsvpnclient)
    name="AWS VPN Client"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        appcastURL="https://d3c4iklh14o4hj.cloudfront.net/OSX_ARM64/latest/appcast.xml"
    else
        appcastURL="https://d3c4iklh14o4hj.cloudfront.net/OSX/latest/appcast.xml"
    fi
    appcastXML="$(curl -fsL "$appcastURL")"
    downloadURL="$(echo "$appcastXML" | xpath 'string(//rss/channel/item[1]/enclosure/@url)' 2>/dev/null)"
    appNewVersion="$(echo "$appcastXML" | xpath 'string(//rss/channel/item[1]/enclosure/@sparkle:version)' 2>/dev/null)"
    expectedTeamID="94KV3E626L"
    ;;
