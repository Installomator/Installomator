teamviewer)
    name="TeamViewer"
    type="pkgInDmg"
    # packageID="com.teamviewer.teamviewer"
    versionKey="CFBundleShortVersionString"
    appCustomVersion() { defaults read /Applications/$appName/Contents/Info.plist $versionKey } # Fixes problem when Installomator thinks that TeamViewer is already installed when the same version of TeamViewerQS is installed on the device
    pkgName="Install TeamViewer.app/Contents/Resources/Install TeamViewer.pkg"
    downloadURL="https://download.teamviewer.com/download/TeamViewer.dmg"
    appNewVersion=$(curl -s -L -X GET "https://jamf-patch.jamfcloud.com/v1/patch/1C2" -H "Accept: application/json" --output - | security cms -D | plutil -convert json -r -o - - | grep "currentVersion" | cut -d '"' -f 4)
    #appNewVersion=$(curl -fs "https://www.teamviewer.com/en/download/macos/" | grep "Current version" | awk -F': ' '{ print $2 }' | sed 's/<[^>]*>//g')
    expectedTeamID="H7UGFBUGV6"
    ;;
