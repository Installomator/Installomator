shottr)
    name="Shottr"
    type="dmg"
    downloadURL="https://shottr.cc$(curl -fs "https://shottr.cc/newversion.html" | grep -o '\/dl\/Shottr-[0-9].[0-9].[0-9]\.dmg' | head -1 | xargs)"
    appNewVersion=$(echo $downloadURL | grep -o '[0-9].[0-9].[0-9]' | xargs)
    expectedTeamID="2Y683PRQWN"
    ;;
