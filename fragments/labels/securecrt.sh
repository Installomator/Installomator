securecrt)
    name="SecureCRT"
    type="dmg"
    releasePage=$(curl -fs "https://www.vandyke.com/cgi-bin/releases.php?product=securecrt")
    if [[ $(arch) == "arm64" ]]; then
        archiveName=$(echo "$releasePage" | grep -o 'scrt-[0-9.]*-[0-9]*\.macos_arm64\.dmg' | head -1)
        pid=$(echo "$releasePage" | grep -o 'pid=scrt_mac_arm64_[0-9]*' | head -1 | cut -d= -f2)
    else
        archiveName=$(echo "$releasePage" | grep -o 'scrt-[0-9.]*-[0-9]*\.macos_x64\.dmg' | head -1)
        pid=$(echo "$releasePage" | grep -o 'pid=scrt_macx64_[0-9]*' | head -1 | cut -d= -f2)
    fi
    appNewVersion=$(echo "$archiveName" | sed -E 's/scrt-([0-9.]+)-.*/\1/')
    countryCode=$(defaults read /Library/Preferences/.GlobalPreferences Country 2>/dev/null | tr '[:upper:]' '[:lower:]')
    [[ -z "$countryCode" ]] && countryCode="us"
    downloadURL="https://www.vandyke.com/cgi-bin/download_1.php"
    curlOptions=(--request POST --data "pid=$pid" --data "export_check=accept" --data "country=$countryCode")
    expectedTeamID="9M229JAFBZ"
    ;;
