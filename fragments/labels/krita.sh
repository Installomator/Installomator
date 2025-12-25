krita)
    # credit: Søren Theilgaard (@theilgaard)
    name="krita"
    type="dmg"
    downloadURL=$( curl -fsL "https://krita.org/en/download" | grep ".*https.*stable.*dmg.*" | head -1 | sed -E 's/.*(https.*dmg).*/\1/g' )
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)-.*/\1/g' )
    expectedTeamID="DL93766A3G"
    ;;
