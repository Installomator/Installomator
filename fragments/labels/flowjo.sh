flowjo)
    name="FlowJo"
    type="dmg"
    downloadURL="$(curl -fs "https://www.flowjo.com/solutions/flowjo/downloads" | grep -i -o -E "https.*\.dmg")"
    appNewVersion=$(echo "${downloadURL}" | tr "-" "\n" | grep dmg | sed -E 's/([0-9.]*)\.dmg/\1/g')
    expectedTeamID="C79HU5AD9V"
    ;;
