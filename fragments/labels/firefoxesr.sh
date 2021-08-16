firefoxesr|\
firefoxesrpkg)
    name="Firefox"
    type="pkg"
    downloadURL="https://download.mozilla.org/?product=firefox-esr-pkg-latest-ssl&os=osx"
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*releases\/([0-9.]*)esr.*/\1/g')
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;
