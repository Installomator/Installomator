brave)
    name="Brave Browser"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="Brave-Browser-arm64.dmg"
    else
        archiveName="Brave-Browser-x64.dmg"
    fi
    downloadURL=$(downloadURLFromGit brave brave-browser)
    appNewVersion=$(versionFromGit brave brave-browser)
    appCustomVersion() { defaults read "/Applications/Brave Browser.app/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null | cut -d. -f2- }
    expectedTeamID="KL8N8XSYF4"
    ;;
