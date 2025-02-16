ujamportal)
    name="UJAM"
    type="dmg"
    appNewVersion="$(curl -s -i "https://software.ujam.com/ujamapp/latest-mac.yml" | grep "version" | cut -d" " -f2 | xargs)"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://software.ujam.com/ujamapp/UJAM-${appNewVersion}-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://software.ujam.com/ujamapp/UJAM-${appNewVersion}.dmg"
    fi
    expectedTeamID="9PRN6T272N"
    ;;
