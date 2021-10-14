yed)
    # This label assumes accept of these T&C’s: https://www.yworks.com/resources/yed/license.html
    name="yEd"
    type="dmg"
    downloadURL="https://www.yworks.com"$(curl -fs "https://www.yworks.com/products/yed/download" | grep -o -e "/resources/.*\.dmg" | tr " " '\n' | grep -o -e "/resources/.*\.dmg")
    appNewVersion=$(echo $downloadURL | sed -E 's/.*-([0-9.]*)_.*\.dmg/\1/')
    expectedTeamID="JD89S887M2"
    ;;
