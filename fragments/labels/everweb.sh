everweb)
    name="EverWeb"
    type="dmg"
    downloadURL="https://www.ragesw.com/downloads/everweb/everweb.dmg"
    appNewVersion=$(curl -fs https://www.everwebapp.com/change-log/index.html | grep -oE "[0-9]+\.[0-9]+\.[0-9]+" | head -n 1)
    expectedTeamID="A95T4TFRZ2"
    ;;
