lulu)
    name="LuLu"
    type="dmg"
    downloadURL=$( curl -fs "https://objective-see.com/products/lulu.html" | grep https | grep "$type" | head -1 | tr '"' "\n" | grep "^http" )
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*_([0-9.]*)\..*/\1/g' )
    expectedTeamID="VBG97UB4TA"
    ;;
