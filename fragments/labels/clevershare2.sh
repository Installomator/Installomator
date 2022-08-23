clevershare2)
    name="Clevershare"
    type="dmg"
    printlog "Label for $name broken in test" WARN
    downloadURL=$(curl -fs https://www.clevertouch.com/eu/clevershare2g | grep -i -o -E "https.*Mac.*\.dmg")
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z-]*_Mac\.([0-9.]*)\.[0-9]*\.dmg$/\1/g' )
    expectedTeamID="P76M9BE8DQ"
    ;;
