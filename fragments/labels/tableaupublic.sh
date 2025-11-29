tableaupublic)
    name="Tableau Public"
    type="pkgInDmg"
    packageID="com.tableausoftware.tableaupublic"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fs https://www.tableau.com/downloads/public/mac-arm64 | awk '/TableauPublic/' | xmllint --recover --html --xpath "//a/text()" -)
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fs https://www.tableau.com/downloads/public/mac | awk '/TableauPublic/' | xmllint --recover --html --xpath "//a/text()" -)
    fi
    appNewVersion=$( echo $downloadURL | sed -E 's/.*TableauPublic-([-0-9]*)\.dmg/\1/g' | tr "-" "." )
    expectedTeamID="QJ4XPRK37C"
    ;;
