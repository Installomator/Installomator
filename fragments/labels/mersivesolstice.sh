mersivesolstice)
    name="Mersive Solstice"
    type="dmg"
    appNewVersion=$(curl -fsL "https://documentation.mersive.com/en/solstice/solstice-release-notes.html" | grep -Eo "Solstice Version [0-9]+\.[0-9]+\.[0-9]+" | head -n 1 | awk '{print $3}')
    downloadURL="https://www.mersive.com/downloads/SolsticeClient-${appNewVersion}.dmg"
    expectedTeamID="63B5A5WDNG"
    appCustomVersion() {
        defaults read "/Applications/Mersive Solstice.app/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null
    }
    ;;
