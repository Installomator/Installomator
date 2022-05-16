firefox)
    name="Firefox"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US"
    appNewVersion=$(curl -fs https://www.mozilla.org/en-US/firefox/releases/ | grep '<html' | grep -o -i -e "data-latest-firefox=\"[0-9.]*\"" | cut -d '"' -f2)
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    printlog "WARNING for ERROR: Label firefox and firefox_intl should not be used. Instead use firefoxpkg and firefoxpkg_intl as per recommendations from Firefox. It's not fully certain that the app actually gets updated here. firefoxpkg and firefoxpkg_intl will have built in updates and make sure the client is updated in the future." REQ
    ;;
