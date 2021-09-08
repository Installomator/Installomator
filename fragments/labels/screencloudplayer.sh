screencloudplayer)
    # credit: AP Orlebeke (@apizz)
    name="ScreenCloud Player"
    type="dmg"
    downloadURL=$(curl -sL "https://screencloud.com/download" | sed -n 's/^.*"url":"\([^"]*\)".*$/\1/p')
    expectedTeamID="3C4F953K6P"
    ;;