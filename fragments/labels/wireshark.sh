wireshark)
    name="Wireshark"
    type="dmg"
    appNewVersion=$(curl -fs "https://www.wireshark.org/update/0/Wireshark/4.0.0/macOS/x86-64/en-US/stable.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:version)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)
    if [[ $(arch) == i386 ]]; then
      downloadURL="https://1.as.dl.wireshark.org/osx/Wireshark%20Latest%20Intel%2064.dmg"
    elif [[ $(arch) == arm64 ]]; then
      downloadURL="https://1.as.dl.wireshark.org/osx/Wireshark%20Latest%20Arm%2064.dmg"
    fi
    expectedTeamID="7Z6EMTD2C6"
    ;;
