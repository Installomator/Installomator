wireshark)
    name="Wireshark"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
      downloadURL="https://1.as.dl.wireshark.org/osx/Wireshark%20Latest%20Intel%2064.dmg"
    elif [[ $(arch) == arm64 ]]; then
      downloadURL="https://1.as.dl.wireshark.org/osx/Wireshark%20Latest%20Arm%2064.dmg"
    fi
    appNewVersion=$(curl -fs https://www.wireshark.org/download.html | grep "Stable Release" | grep -o "(.*.)" | cut -f2 | head -1 | awk -F '[()]' '{print $2}')
    expectedTeamID="7Z6EMTD2C6"
    ;;
