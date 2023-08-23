textexpander)
    name="TextExpander"
    type="dmg"
    downloadURL="$(curl -s -L -w "%{url_effective}\n" -o /dev/null "https://rest-prod.tenet.textexpander.com/download?platform=macos")"
    appNewVersion=$( echo "$downloadURL" | sed -n 's/.*TextExpander_\([0-9.]*\).dmg/\1/p' | grep -oE '[0-9.]+' )
    expectedTeamID="7PKJ6G4DXL"
    ;;
