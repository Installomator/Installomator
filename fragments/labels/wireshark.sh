wireshark)
    name="Wireshark"
    type="dmg"
    appNewVersion=$(curl -fs https://www.wireshark.org/download.html | grep -i "href.*_stable" | sed -E 's/.*\(([0-9.]*)\).*/\1/g')
    if [[ $(arch) == i386 ]]; then
      downloadURL="https://1.as.dl.wireshark.org/osx/Wireshark%20$appNewVersion%20Intel%2064.dmg"
    elif [[ $(arch) == arm64 ]]; then
      downloadURL="https://1.as.dl.wireshark.org/osx/Wireshark%20$appNewVersion%20Arm%2064.dmg"
    fi
    expectedTeamID="7Z6EMTD2C6"
    ;;
