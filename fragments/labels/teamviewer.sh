teamviewer)
    name="TeamViewer"
    type="pkgInDmg"
    # packageID="com.teamviewer.teamviewer"
    versionKey="CFBundleShortVersionString"
    pkgName="Install TeamViewer.app/Contents/Resources/Install TeamViewer.pkg"
    downloadURL="https://download.teamviewer.com/download/TeamViewer.dmg"
    appNewVersion=$(curl -fs "https://www.teamviewer.com/en/download/macos/" | grep 'data-json' | grep 'full' | grep -oE "versionNumber&quot;:&quot;[0-9\.]*" | grep -oE "[0-9\.]*")
    expectedTeamID="H7UGFBUGV6"
    ;;
