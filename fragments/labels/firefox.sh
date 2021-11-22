firefox)
    name="Firefox"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US"
    appNewVersion=$(curl -fs https://www.mozilla.org/en-US/firefox/releases/ | grep '<html' | grep -o -i -e "data-latest-firefox=\"[0-9.]*\"" | cut -d '"' -f2)
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;
