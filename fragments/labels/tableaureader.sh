tableaureader)
    name="Tableau Reader"
    type="pkgInDmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://www.tableau.com/downloads/reader/mac-arm64"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://www.tableau.com/downloads/reader/mac"
    fi
    appNewVersion=${$(curl -fsIL "$downloadURL" | sed -nE 's/.*Reader-([0-9-]*).*/\1/p')//-/.}
    appNewVersion=$( echo "$appNewVersion" | sed -r 's/\.$//' )
    expectedTeamID="QJ4XPRK37C"
    ;;
