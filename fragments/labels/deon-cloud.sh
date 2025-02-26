deon-cloud)
    name="Deon"
    type="dmg"
    PackageId="de.deon.macos"
    downloadURL="https://download.deon.de/mac-cloud/latest"
    appNewVersion=$(curl -sfLI "https://download.deon.de/index.php?action=2&product=Mac&channel=cloud" | grep -o 'filename="[^"]*"' | sed 's/.*_\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)\.dmg.*/\1/')
    expectedTeamID="EW9H238RWQ"
    ;;
