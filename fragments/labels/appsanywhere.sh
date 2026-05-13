appsanywhere)
    name="AppsAnywhere Client (macOS)"
    type="pkg"
    aaClientReleasePage="https://docs.appsanywhere.com/appsanywhere/3.2/appsanywhere-client-macos"
    latestVersion="$(
      /usr/bin/curl -fsSL "$aaClientReleasePage" \
      | /usr/bin/sed -nE 's/.*id="AppsAnywhereClient\(macOS\)-Version([0-9]+\.[0-9]+\.[0-9]+)\(CurrentVersion\)".*/\1/p' \
      | /usr/bin/head -n 1
    )"
    if [[ -z "$latestVersion" ]]; then
        printlog "ERROR: Could not determine latest AppsAnywhere macOS client version from $aaClientReleasePage"
        cleanupAndExit 99
    fi
    downloadURL="https://files.appsanywhere.com/clients/appsanywhere/mac/${latestVersion}/apps-anywhere-setup-InstitutionId-${latestVersion}.pkg"
    pkgName="apps-anywhere-setup-InstitutionId-${latestVersion}.pkg"
    expectedTeamID="9ZNX23CMVD"
    appCustomVersion(){
        /usr/bin/defaults read "/Applications/AppsAnywhere/AppsAnywhere.app/Contents/Info" CFBundleShortVersionString 2>/dev/null || echo "0"
    }
    appNewVersion="$latestVersion"
    updateTool="/Applications/AppsAnywhere/AppsAnywhere Updater.app/Contents/MacOS/AppsAnywhere Updater"
    ;;
