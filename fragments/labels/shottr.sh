shottr)
    name="Shottr"
    type="dmg"
    downloadURL="https://shottr.cc/dl/Shottr-1.5.3.dmg"
    appNewVersion=$( echo ${downloadURL} | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="2Y683PRQWN"
    ;;
