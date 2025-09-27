teamviewer)
    name="TeamViewer"
    type="pkgInDmg"
    # packageID="com.teamviewer.teamviewer"
    versionKey="CFBundleShortVersionString"
    pkgName="Install TeamViewer.app/Contents/Resources/Install TeamViewer.pkg"
    downloadURL="https://download.teamviewer.com/download/TeamViewer.dmg"
    appNewVersion=$(curl -fs "https://www.teamviewer.com/en/download/macos/" | grep 'data-json' | grep 'full' | awk -F '"' '{ print $4 }' | sed 's/&quot;/"/g' | plutil -extract "data.0.versionNumber" raw -o - -)
    expectedTeamID="H7UGFBUGV6"
    ;;
