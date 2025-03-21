papers)
    name="Papers"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.readcube.com/app/Papers_Setup-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.readcube.com/app/Papers_Setup-x64.dmg"
    fi
    appNewVersion="$(curl -fs "https://update.readcube.com/desktop/updates/latest-mac.yml" | grep "version:" | awk '{ print $2 }')"
    expectedTeamID="FY6R4ETYH7"
    ;;
