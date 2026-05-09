teamviewerqs)
    name="TeamViewerQS"
    type="dmg"
    downloadURL="https://download.teamviewer.com/download/TeamViewerQS.dmg"
    appNewVersion=$(getJSONValue "$(curl -fsL https://www.teamviewer.com/en/solutions/use-cases/quicksupport/ | grep .dmg |  grep -o 'data-json="[^"]*"' | sed 's/data-json="//;s/"$//' | sed 's/&quot;/"/g' )" "data[0].versionNumber")
    expectedTeamID="H7UGFBUGV6"
    ;;
