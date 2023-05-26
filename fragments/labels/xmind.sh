xmind)
    name="Xmind"
    type="dmg"
    downloadURL=https://www.xmind.net/zen/download/mac/
    appNewVersion=$(echo $downloadURL | grep -oe "http.*\.dmg" | sed -e 's/.*\/Xmind-for-macOS-.*\-\([0-9.]*\)\.dmg/\1/g')
    expectedTeamID="4WV38P2X5K"
    ;;
