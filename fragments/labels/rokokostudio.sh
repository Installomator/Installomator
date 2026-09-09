rokokostudio)
    name="Rokoko Studio"
    type="pkg"
    downloadURL="https://downloads.rokoko.com/studio-mac"
    appNewVersion=$(curl -fsL -r 0-0 -o /dev/null -w "%{url_effective}" "$downloadURL" | grep -oE '[0-9]+(\.[0-9]+)+')
    expectedTeamID="5K4RZM8SUS"
    ;;
