wickrpro)
    # credit: Søren Theilgaard (@theilgaard)
    name="WickrPro"
    type="dmg"
    downloadURL=$( curl -fs https://me-download.wickr.com/api/download/pro/download/mac | tr '"' '\n' | grep -e '^https://' )
    appNewVersion=$( echo ${downloadURL} | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="W8RC3R952A"
    ;;
