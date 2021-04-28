fantastical)
    # credit: Drew Diver (@grumpydrew on MacAdmins Slack)
    name="Fantastical"
    type="zip"
    downloadURL="https://flexibits.com/fantastical/download"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z]*_([0-9.]*)\..*/\1/g' )
    expectedTeamID="85C27NK92C"
    ;;
