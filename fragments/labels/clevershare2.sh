clevershare2)
    name="Clevershare"
    type="dmg"
    printlog "Label for $name broken in test" ERROR
    downloadURL=$(curl -fs https://www.clevertouch.com/eu/clevershare2g | grep -i -o -E "https.*notarized.*\.dmg")
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/([0-9.]*)\/[0-9]*\/.*\.dmg$/\1/')
    expectedTeamID="P76M9BE8DQ"
    ;;
