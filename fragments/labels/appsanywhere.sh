appsanywhere)
    name="AppsAnywhere"
    type="pkg"
    appName="AppsAnywhere/AppsAnywhere.app"
    packageID="com.s2.pkg.AppsAnywhere"
    appNewVersion="$(curl -fsSL "https://docs.appsanywhere.com$(curl -fsSL "https://docs.appsanywhere.com/client/-/macos-client-release-notes" | tr -d '\n' | grep -Eo '<a[^>]+href="[^"]*macos(-client)?-[0-9]+-[0-9]+(-[0-9]+)?"[^>]*>[^<]*macOS[[:space:]]+Client[[:space:]]+[0-9]+\.[0-9]+' | sed -E 's/.*href="([^"]*)".*/\1/' | head -n1)" | sed -nE 's/.*Version[[:space:]]+([0-9]+\.[0-9]+\.[0-9]+).*/\1/p' | head -n1)"
    downloadURL="https://files.appsanywhere.com/clients/appsanywhere/mac/${appNewVersion}/apps-anywhere-setup-InstitutionId-${appNewVersion}.pkg"
    expectedTeamID="9ZNX23CMVD"
    ;;
