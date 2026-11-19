mailviewer)
    name="Mailviewer"
    type="pkg"
    mailviewerJSON=$(curl -fsL "https://updates.mailviewer.app/latest.json")
    downloadURL=$(getJSONValue "$mailviewerJSON" "url")
    appNewVersion=$(getJSONValue "$mailviewerJSON" "pkgVersion")
    appCustomVersion(){ if [ -e "/Applications/Mailviewer.app" ]; then echo "$(defaults read "/Applications/Mailviewer.app/Contents/Info.plist" CFBundleShortVersionString).$(defaults read "/Applications/Mailviewer.app/Contents/Info.plist" CFBundleVersion)"; fi; }
    expectedTeamID="D7PHX968FZ"
    ;;
