appsanywhere)
    name="AppsAnywhere Client (macOS)"
    type="pkg"
    appName="AppsAnywhere.app"
    appCustomVersion=$(/usr/bin/defaults read "/Applications/AppsAnywhere/AppsAnywhere.app/Contents/Info" CFBundleShortVersionString 2>/dev/null || echo "0")
    appNewVersion="$(/usr/bin/curl -fsSL "https://docs.appsanywhere.com$(/usr/bin/curl -fsSL "https://docs.appsanywhere.com/client/-/macos-client-release-notes" 2>/dev/null | /usr/bin/tr -d '\n' | /usr/bin/grep -Eo '<a[^>]+href="[^"]*macos(-client)?-[0-9]+-[0-9]+(-[0-9]+)?"[^>]*>[^<]*macOS[[:space:]]+Client[[:space:]]+[0-9]+\.[0-9]+' | /usr/bin/sed -E 's/.*href="([^"]*)".*/\1/' | /usr/bin/head -n1)" 2>/dev/null | /usr/bin/sed -nE 's/.*Version[[:space:]]+([0-9]+\.[0-9]+\.[0-9]+).*/\1/p' | /usr/bin/sort -u | /usr/bin/awk -F. '{ printf "%03d%03d%03d %s\n", $1, $2, $3, $0 }' | /usr/bin/sort -r | /usr/bin/awk 'NR==1{ print $2 }')"
    downloadURL="https://files.appsanywhere.com/clients/appsanywhere/mac/${appNewVersion}/apps-anywhere-setup-InstitutionId-${appNewVersion}.pkg"
    pkgName="apps-anywhere-setup-InstitutionId-${appNewVersion}.pkg"
    expectedTeamID="9ZNX23CMVD"
    ;;
