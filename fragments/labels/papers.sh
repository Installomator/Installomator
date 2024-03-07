papers)
    name="Papers"
    type="dmg"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL="https://download.readcube.com/app/Papers_Setup-arm64.dmg"
    else
        downloadURL="https://download.readcube.com/app/Papers_Setup-x64.dmg"
    fi    appNewVersion=""
    expectedTeamID="FY6R4ETYH7"
    ;;
