rokokostudio)
    name="RokokoStudio"
    type="pkg"
    packageID="com.rokoko.pkg.rokokostudio"
    downloadURL="https://downloads.rokoko.com/studio-mac"
    appNewVersion=$(curl -Ls -o /dev/null -w %{url_effective} https://downloads.rokoko.com/studio-mac | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
    versionKey="CFBundleVersion"
    expectedTeamID="5K4RZM8SUS"
    ;;
