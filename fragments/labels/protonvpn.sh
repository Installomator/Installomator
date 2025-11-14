protonvpn)
    name="ProtonVPN"
    type="dmg"
    downloadURL=$(curl -s "https://protonvpn.com/download/macos-update5.xml" | xmllint --xpath 'string(//item[not(*[local-name()="channel" and .="beta"])]/enclosure/@url)' -)
    appNewVersion=$(echo $downloadURL | sed -e 's/^.*\/Proton.*_v\([0-9.]*\)\.dmg/\1/g')
    expectedTeamID="J6S6Q257EK"
    ;;
