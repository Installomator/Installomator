wickrme)
    # Label  not working, haven't found a solution
    name="WickrMe"
    printlog "Label for $name broken in test" WARN
    type="dmg"
    downloadURL=$( curl -fs https://me-download.wickr.com/api/download/me/download/mac | tr '"' '\n' | grep -e '^https://' )
    appNewVersion=$( echo ${downloadURL} | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="W8RC3R952A"
    ;;
