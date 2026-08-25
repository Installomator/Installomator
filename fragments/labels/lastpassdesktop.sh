lastpassdesktop)
    name="LastPass for Desktop"
    type="dmg"
    downloadURL="https://download.cloud.lastpass.com/lastpass-for-desktop-macos/universal/LastPassForDesktopMac.dmg"
    appNewVersion=$(curl -fsL "https://lastpass.com/misc_download2.php" | tr "<>" "\n\n" | awk '/id="macos-app"/{found=1} found && /Version [0-9]+\.[0-9]+\.[0-9]+/{print $2; exit}')
    appCustomVersion() { /usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "/Applications/LastPass for Desktop.app/Contents/Info.plist" | sed -E 's/-[0-9]+$//'; }
    expectedTeamID="RNDLY9ZML8"
    ;;
