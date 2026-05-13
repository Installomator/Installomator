microsoftonedrivesuinsiders)
    # This label uses the same XML feed that the OneDrive StandaloneUpdater tool uses to find the Insiders version of OneDrive updates.
    # Microsoft OneDrive StandaloneUpdater Insiders
    name="OneDrive"
    type="pkg"
    onedriveFeed="https://g.live.com/0USSDMC_W5T/MacODSUInsiders"
    downloadURL="$(curl -fsL "${onedriveFeed}" | grep -A1 "UniversalPkgBinaryURL" | tail -1 | cut -d'>' -f2 | cut -d'<' -f1)"
    appNewVersion="$(curl -fsL "${onedriveFeed}" | grep -A1 "CFBundleShortVersionString" | tail -1 | cut -d'>' -f2 | cut -d'<' -f1)"
    expectedTeamID="UBF8T346G9"
    ;;
