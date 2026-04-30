clevershare2)
    name="Clevershare"
    type="dmg"
    downloadURL=$(curl -fs https://www.clevertouch.com/uk/clevershare2g | grep -i -o -E "https.*validated.*\.dmg")
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/([0-9.]*)\/[0-9]*\/.*\.dmg$/\1/')
    expectedTeamID="LHZP4ZQ39M"
    ;;
