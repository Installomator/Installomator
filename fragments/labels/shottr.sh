shottr)
    name="Shottr"
    type="dmg"
    appNewVersion=$(curl -s https://shottr.cc/newversion.html | grep "Shottr v" | head -1 | sed 's/.*v\([0-9.]*\).*/\1/')
    downloadURL="https://shottr.cc/dl/Shottr-${appNewVersion}.dmg"
    expectedTeamID="2Y683PRQWN"
    ;;
