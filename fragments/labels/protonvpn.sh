protonvpn)
    name="ProtonVPN"
    type="dmg"
    downloadURL=$(curl -s "https://protonvpn.com/download/macos-update3.xml" | xmllint --xpath 'string(//enclosure/@url)' -)
    appNewVersion=$(echo $downloadURL | sed -e 's/^.*\/Proton.*_v\([0-9.]*\)\.dmg/\1/g')
    expectedTeamID="J6S6Q257EK"
    ;;
