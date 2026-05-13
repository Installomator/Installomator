microsoftonedrivesuprod)
    # This label uses the same XML feed that the OneDrive StandaloneUpdater tool uses to find the production version of OneDrive updates.
    # Microsoft OneDrive StandaloneUpdater Production
    name="OneDrive"
    type="pkg"
    onedriveFeed="https://g.live.com/0USSDMC_W5T/MacODSUProduction"
    downloadURL="$(curl -fsL "${onedriveFeed}" | grep -A1 "UniversalPkgBinaryURL" | tail -1 | cut -d'>' -f2 | cut -d'<' -f1)"
    appNewVersion="$(curl -fsL "${onedriveFeed}" | grep -A1 "CFBundleShortVersionString" | tail -1 | cut -d'>' -f2 | cut -d'<' -f1)"
    expectedTeamID="UBF8T346G9"
    ;;
