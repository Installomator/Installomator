firefox)
    name="Firefox"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US"
    firefoxVersions=$(curl -fs "https://product-details.mozilla.org/1.0/firefox_versions.json")
    appNewVersion=$(getJSONValue "$firefoxVersions" "LATEST_FIREFOX_VERSION")
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    printlog "WARNING for ERROR: Label firefox and firefox_intl should not be used. Instead use firefoxpkg and firefoxpkg_intl as per recommendations from Firefox. It's not fully certain that the app actually gets updated here. firefoxpkg and firefoxpkg_intl will have built in updates and make sure the client is updated in the future." REQ
    ;;
