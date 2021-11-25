firefox_da)
    name="Firefox"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=firefox-latest&amp;os=osx&amp;lang=da"
    appNewVersion=$(curl -fs https://www.mozilla.org/en-US/firefox/releases/ | grep '<html' | grep -o -i -e "data-latest-firefox=\"[0-9.]*\"" | cut -d '"' -f2)
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;
