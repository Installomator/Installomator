tableaureader)
    name="Tableau Reader"
    type="pkg"
    tableauUpdateFeed=$(curl -fsL "https://downloads.tableau.com/TableauAutoUpdate.xml")
    latestVersion=$(echo "${tableauUpdateFeed}" | xmllint --xpath '//*[local-name()="version"]/@latestVersion' - | tr ' ' '\n' | awk -F'"' '{print $2}' | sort -nr | head -n1)
    nameVersion=$(echo "${tableauUpdateFeed}" | xmllint --xpath "//*[local-name()='version'][@latestVersion='$latestVersion']/@name" - 2>/dev/null | awk -F'"' '{print $2}')
    name="${name} ${nameVersion}"
    appNewVersion=$(echo "${tableauUpdateFeed}" | xmllint --xpath "//*[local-name()='version'][@latestVersion='$latestVersion']/@releaseNotesVersion" - | awk -F'"' '{print $2}')
    if [[ $(arch) == "arm64" ]]; then
        readerMac=$(echo "${tableauUpdateFeed}" | xmllint --xpath "//*[local-name()='version'][@latestVersion='$latestVersion']//*[local-name()='installer'][@type='readerMacArm64']/@name" - | awk -F'"' '{print $2}')
    elif [[ $(arch) == "i386" ]]; then
        readerMac=$(echo "${tableauUpdateFeed}"  | xmllint --xpath "//*[local-name()='version'][@latestVersion='$latestVersion']//*[local-name()='installer'][@type='readerMac']/@name" - | awk -F'"' '{print $2}')
    fi
    downloadURL="https://downloads.tableau.com/esdalt/$appNewVersion/$readerMac"
    expectedTeamID="QJ4XPRK37C"
    ;;

