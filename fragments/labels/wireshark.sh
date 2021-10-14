wireshark)
    # credit: Oh4sh0 https://github.com/Oh4sh0
    name="Wireshark"
    type="dmg"
    downloadURL="https://1.as.dl.wireshark.org/osx/Wireshark%20Latest%20Intel%2064.dmg"
    appNewVersion=$(curl -fs https://www.wireshark.org/download.html | grep "Stable Release" | grep -o "(.*.)" | cut -f2 | head -1 | awk -F '[()]' '{print $2}')
    expectedTeamID="7Z6EMTD2C6"
    ;;
