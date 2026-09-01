tableaupublic)
    name="Tableau Public"
    type="pkgInDmg"
    if [[ $(arch) == "arm64" ]]; then
        # The Apple silicon build installs a differently named bundle. Without appName
        # Installomator looks for "Tableau Public.app" and cannot read the installed
        # version, so it reinstalls on every run.
        appName="Tableau Public (Apple silicon).app"
        downloadURL=$(curl -fsIL -o /dev/null -w "%{url_effective}" "https://www.tableau.com/downloads/public/mac-arm64")
    elif [[ $(arch) == "i386" ]]; then
        appName="Tableau Public.app"
        downloadURL=$(curl -fsIL -o /dev/null -w "%{url_effective}" "https://www.tableau.com/downloads/public/mac")
    fi
    appNewVersion=$(echo "$downloadURL" | sed -E 's#.*TableauPublic-([0-9]+)-([0-9]+)-([0-9]+)(-arm64)?\.dmg#\1.\2.\3#')
    expectedTeamID="QJ4XPRK37C"
    ;;
