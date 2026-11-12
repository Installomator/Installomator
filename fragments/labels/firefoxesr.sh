firefoxesr|\
firefoxesrpkg)
    name="Firefox"
    type="pkg"
    downloadURL="https://download.mozilla.org/?product=firefox-esr-pkg-latest-ssl&os=osx&lang=en-US"
    appNewVersion=$(getJSONValue "$(curl -fsL "https://product-details.mozilla.org/1.0/firefox_versions.json")" "FIREFOX_ESR" | sed 's/esr$//')
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;
