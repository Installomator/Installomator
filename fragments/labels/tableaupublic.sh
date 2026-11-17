tableaupublic)
    name="Tableau Public"
    type="pkgInDmg"
    if [[ $(arch) == "arm64" ]]; then
        appName="Tableau Public (Apple silicon).app"
        tableauPublicPath="mac-arm64"
    elif [[ $(arch) == "i386" ]]; then
        appName="Tableau Public.app"
        tableauPublicPath="mac"
    fi
    downloadURL=$(curl -fsIL -o /dev/null -w "%{url_effective}" "https://www.tableau.com/downloads/public/${tableauPublicPath}")
    appNewVersion=$(echo "$downloadURL" | sed -En 's#.*TableauPublic-([0-9]+)-([0-9]+)-([0-9]+)(-arm64)?\.dmg#\1.\2.\3#p')
    expectedTeamID="QJ4XPRK37C"
    ;;
