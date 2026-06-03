fiddlereverywhere)
    name="Fiddler Everywhere"
    type="dmg"
    downloadURL="https://api.getfiddler.com/mac/latest-mac"
    appNewVersion=$(curl -fsL -w "%{url_effective}" -o /dev/null "$downloadURL" | sed -E 's|.*Fiddler%20Everywhere%20([0-9.]+)\.dmg|\1|')
    expectedTeamID="CHSQ3M3P37"
    ;;
