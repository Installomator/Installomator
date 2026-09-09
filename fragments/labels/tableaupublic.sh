tableaupublic)
    name="Tableau Public"
    type="pkgInDmg"
    if [[ $(arch) == "arm64" ]]; then
        appName="Tableau Public (Apple silicon).app"
        downloadURL=$(curl -fsIL -o /dev/null -w "%{url_effective}" "https://www.tableau.com/downloads/public/mac-arm64")
    elif [[ $(arch) == "i386" ]]; then
        appName="Tableau Public.app"
        downloadURL=$(curl -fsIL -o /dev/null -w "%{url_effective}" "https://www.tableau.com/downloads/public/mac")
    fi
    appNewVersion=$(echo "$downloadURL" | sed -E 's#.*TableauPublic-([0-9]+)-([0-9]+)-([0-9]+)(-arm64)?\.dmg#\1.\2.\3#')
    blockingProcesses=( "Tableau Public" )
    expectedTeamID="QJ4XPRK37C"
    ;;
