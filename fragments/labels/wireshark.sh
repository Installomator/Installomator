wireshark)
    name="Wireshark"
    type="dmg"
    appNewVersion=$(curl -fs https://www.wireshark.org/download.html | grep -io "<p>The current stable release of Wireshark is *[0-9.]* It supersedes all previous releases.</p>" | sed -e 's/.*The current stable release of Wireshark is \(.*\). It supersedes all previous releases.*/\1/')
    if [[ $(arch) == i386 ]]; then
      downloadURL="https://1.as.dl.wireshark.org/osx/Wireshark%20$appNewVersion%20Intel%2064.dmg"
    elif [[ $(arch) == arm64 ]]; then
      downloadURL="https://1.as.dl.wireshark.org/osx/Wireshark%20$appNewVersion%20Arm%2064.dmg"
    fi
    expectedTeamID="7Z6EMTD2C6"
    ;;
