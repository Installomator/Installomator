wireshark)
    # A widely-used network protocol analyzer that enables users to capture and interactively analyze network traffic in real time
    name="Wireshark"
    type="dmg"
    appNewVersion=$(curl -fs "https://www.wireshark.org/update/0/Wireshark/4.0.0/macOS/x86-64/en-US/stable.xml" | xmllint --xpath '/rss/channel/item/enclosure/@url' - | head -1 | cut -d '"' -f 2 | sed -E 's/.*Wireshark%20([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
    if [[ $(arch) == i386 ]]; then
      downloadURL=$(curl -fs "https://www.wireshark.org/update/0/Wireshark/4.0.0/macOS/x86-64/en-US/stable.xml" | xmllint --xpath '/rss/channel/item/enclosure[@url[contains(., "Intel")]]/@url' - | head -1 | cut -d '"' -f 2)
    elif [[ $(arch) == arm64 ]]; then
      downloadURL=$(echo "https://2.na.dl.wireshark.org/osx/all-versions/Wireshark%20$appNewVersion%20Intel%2064.dmg" | sed 's/all-versions\///; s/Intel/Arm/')
    fi
    expectedTeamID="7Z6EMTD2C6"
    ;;