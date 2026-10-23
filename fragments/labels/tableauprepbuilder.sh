tableauprepbuilder)
    name="Tableau Prep Builder"
    type="pkgInDmg"
    pkgName="Tableau Prep Builder.pkg"
    appNewVersion=$(curl -fsL "https://www.tableau.com/support/releases/prep" | grep -oE 'releases/prep/202[0-9]\.[0-9]+(\.[0-9]+)?' | sed -E 's|.*prep/||' | head -1 | awk -F. '{for (i = NF+1; i <= 3; i++) $i = 0; print $1"."$2"."$3}')
    urlVersion=$(echo "$appNewVersion" | sed -E 's/\./-/g')
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL="https://downloads.tableau.com/esdalt/tableau_prep/${appNewVersion}/TableauPrep-${urlVersion}-arm64.dmg"
    else
        downloadURL="https://downloads.tableau.com/esdalt/tableau_prep/${appNewVersion}/TableauPrep-${urlVersion}.dmg"
    fi
    expectedTeamID="QJ4XPRK37C"
    ;;
