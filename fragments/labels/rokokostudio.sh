rokokostudio)
    name="RokokoStudio"
    type="pkg"
    downloadURL="https://downloads.rokoko.com/studio-mac"
    appNewVersion=$(curl -fsL -o /dev/null -w "%{url_effective}" "$downloadURL" | grep -oE '[0-9]+(\.[0-9]+)+')
    versionKey="CFBundleVersion"
    expectedTeamID="5K4RZM8SUS"
    ;;
    
