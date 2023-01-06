firefoxesr|\
firefoxesrpkg)
    name="Firefox"
    type="pkg"
    downloadURL="https://download.mozilla.org/?product=firefox-esr-pkg-latest-ssl&os=osx"
    firefoxVersions=$(curl -fs "https://product-details.mozilla.org/1.0/firefox_versions.json")
    appNewVersion=$(getJSONValue "$firefoxVersions" "FIREFOX_ESR")
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;
