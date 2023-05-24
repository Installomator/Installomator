teamviewer)
    name="TeamViewer"
    type="pkgInDmg"
    # packageID="com.teamviewer.teamviewer"
    versionKey="CFBundleShortVersionString"
    pkgName="Install TeamViewer.app/Contents/Resources/Install TeamViewer.pkg"
    downloadURL="https://download.teamviewer.com/download/TeamViewer.dmg"
    appNewVersion=$(curl -fs "https://www.teamviewer.com/en/download/macos/" | grep "Current version" | cut -d " " -f3 | cut -d "<" -f1)
    expectedTeamID="H7UGFBUGV6"
    ;;
