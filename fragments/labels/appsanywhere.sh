appsanywhere)
    name="AppsAnywhere Client (macOS)"
    type="pkg"
    appName="AppsAnywhere.app"
    aaClientReleasePage="https://docs.appsanywhere.com/client/-/macos-client-release-notes"
    seriesPath="$(
      /usr/bin/curl -fsSL "$aaClientReleasePage" 2>/dev/null \
      | /usr/bin/tr -d '\n' \
      | /usr/bin/grep -Eo '<a[^>]+href="[^"]*macos-[0-9]+-[0-9]+-[0-9]+"[^>]*>[^<]*macOS[[:space:]]+Client[[:space:]]+[0-9]+\.[0-9]+' \
      | /usr/bin/sed -E 's/.*href="([^"]*)".*/\1/' \
      | /usr/bin/head -n1
    )"
    if [[ -z "$seriesPath" ]]; then
        printlog "ERROR: Could not locate latest macOS Client series link on $aaClientReleasePage"
        cleanupAndExit 99
    fi
    seriesURL="https://docs.appsanywhere.com${seriesPath}"
    latestVersion="$(
      /usr/bin/curl -fsSL "$seriesURL" 2>/dev/null \
      | /usr/bin/sed -nE 's/.*Version[[:space:]]+([0-9]+\.[0-9]+\.[0-9]+).*/\1/p' \
      | /usr/bin/sort -u \
      | /usr/bin/awk -F. '{ printf "%03d%03d%03d %s\n", $1, $2, $3, $0 }' \
      | /usr/bin/sort -r \
      | /usr/bin/awk 'NR==1{ print $2 }'
    )"
    if [[ -z "$latestVersion" ]]; then
        printlog "ERROR: Could not determine latest AppsAnywhere macOS client version from $seriesURL"
        cleanupAndExit 99
    fi
    downloadURL="https://files.appsanywhere.com/clients/appsanywhere/mac/${latestVersion}/apps-anywhere-setup-InstitutionId-${latestVersion}.pkg"
    pkgName="apps-anywhere-setup-InstitutionId-${latestVersion}.pkg"
    expectedTeamID="9ZNX23CMVD"
    appCustomVersion(){
        /usr/bin/defaults read "/Applications/AppsAnywhere/AppsAnywhere.app/Contents/Info" CFBundleShortVersionString 2>/dev/null || echo "0"
    }
    appNewVersion="$latestVersion"
    blockingProcesses=( AppsAnywhere )
    ;;
