wireshark)
    name="Wireshark"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
      sparkleFeedURL="https://www.wireshark.org/update/0/Wireshark/4.0.0/macOS/x86-64/en-US/stable.xml"
    elif [[ $(arch) == arm64 ]]; then
      sparkleFeedURL="https://www.wireshark.org/update/0/Wireshark/4.0.0/macOS/arm64/en-US/stable.xml"
    fi
    sparkleFeed=$(curl -fs "$sparkleFeedURL")
    appNewVersion=$(echo "$sparkleFeed" | xpath '(//rss/channel/item/enclosure/@sparkle:version)[1]' 2>/dev/null | cut -d '"' -f 2)
    downloadURL=$(echo "$sparkleFeed" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="7Z6EMTD2C6"
    ;;
