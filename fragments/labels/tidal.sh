tidal)
    name="TIDAL"
    type="dmg"
    downloadURL="https://download.tidal.com/desktop/TIDAL.dmg"
    appNewVersion=$(curl -fs https://update.tidal.com/updates/latest\?v\=1 | cut -d '"' -f4 | sed -E 's/https.*\/TIDAL\.([0-9.]*)\.zip/\1/g')
    expectedTeamID="GK2243L7KB"
    ;;
