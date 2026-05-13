wireshark)
    name="Wireshark"
    type="dmg"
    # Wireshark is a universal binary as of 4.6.0
    # while the feed URL contains 'x86-64', the download works on both Intel and Apple silicon
    sparkleFeed=$(curl -fs "https://www.wireshark.org/update/0/Wireshark/4.6.0/macOS/x86-64/en-US/stable.xml")
    appNewVersion=$(echo "$sparkleFeed" | xpath '(//rss/channel/item/enclosure/@sparkle:version)[1]' 2>/dev/null | cut -d '"' -f 2)
    downloadURL=$(echo "$sparkleFeed" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="7Z6EMTD2C6"
    ;;
