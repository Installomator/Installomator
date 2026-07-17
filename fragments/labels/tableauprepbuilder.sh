tableauprepbuilder)
    name="Tableau Prep Builder"
    type="pkgInDmg"
    pkgName="Tableau Prep Builder.pkg"
    appNewVersion=$(curl -fsL "https://www.tableau.com/support/releases/prep" \
        | grep -oE 'releases/prep/202[0-9]\.[0-9]+(\.[0-9]+)?' \
        | sed -E 's|.*prep/||' \
        | head -1)
    if [[ $(echo "$appNewVersion" | grep -o '\.' | wc -l) -lt 2 ]]; then
        appNewVersion="${appNewVersion}.0"
    fi
    urlVersion=$(echo "$appNewVersion" | sed -E 's/\./-/g')
    if [[ $(/usr/bin/arch) == "arm64" ]]; then
        downloadURL="https://downloads.tableau.com/esdalt/tableau_prep/${appNewVersion}/TableauPrep-${urlVersion}-arm64.dmg"
    else
        downloadURL="https://downloads.tableau.com/esdalt/tableau_prep/${appNewVersion}/TableauPrep-${urlVersion}.dmg"
    fi
    expectedTeamID="QJ4XPRK37C"
    ;;
