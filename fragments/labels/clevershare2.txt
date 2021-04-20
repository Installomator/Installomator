clevershare2)
    # credit: Søren Theilgaard (@theilgaard)
    name="Clevershare"
    type="dmg"
    downloadURL=$(curl -fs https://archive.clevertouch.com/clevershare2g | grep -i "_Mac" | tr '"' "
" | grep "^http.*dmg")
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z-]*_Mac\.([0-9.]*)\.[0-9]*\.dmg$/\1/g' )
    expectedTeamID="P76M9BE8DQ"
    ;;
