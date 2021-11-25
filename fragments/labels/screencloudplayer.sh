screencloudplayer)
    name="ScreenCloud Player"
    type="dmg"
    downloadURL=$(curl -fs "https://screencloud.com/download" | sed -n 's/^.*"url":"\(https.*\.dmg\)".*$/\1/p')
    appNewVersion=$( echo $downloadURL | sed -e 's/.*\/ScreenCloud.*\-\([0-9.]*\)\.dmg/\1/g' )
    expectedTeamID="3C4F953K6P"
    ;;
