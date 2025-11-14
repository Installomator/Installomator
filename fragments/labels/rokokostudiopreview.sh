rokokostudiopreview)
    name="Rokoko Studio Preview"
    appName="Rokoko Studio Preview.app"
    type="dmg"
    downloadURL=$(curl -s https://www.rokoko.com/products/studio/studio-preview | grep -oE 'https[^"]+Rokoko\+Studio\+Preview-[0-9]+\.[0-9]+\.[0-9]+-arm64\.dmg' | sort -V | tail -n1)
    appNewVersion=$(echo $downloadURL | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')
    versionKey="CFBundleVersion"
    expectedTeamID="5K4RZM8SUS"
    ;;

