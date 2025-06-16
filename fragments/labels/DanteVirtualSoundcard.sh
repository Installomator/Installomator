dantevirtualsoundcard)
    name="Dante Virtual Soundcard"
    type="pkgInDmg"
    appNewVersion=$(curl -sL https://my.audinate.com/support/downloads/download-latest-dante-software | grep -oE 'Dante Virtual Soundcard v[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+ for macOS' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    downloadURL="https://my.audinate.com/system/files/release/DVS-${appNewVersion}_macos.dmg"
    versionKey="CFBundleVersion"
    expectedTeamID="P4WCR6Y822"
    ;;
