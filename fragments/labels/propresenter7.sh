propresenter7)
    name="ProPresenter 7"
    appName="ProPresenter.app"
    type="zip"
    blockingProcesses="ProPresenter"
    downloadURL=$(curl -s "https://api.renewedvision.com/v1/pro/upgrade?platform=macos&osVersion=12&appVersion=771&buildNumber=117899527&includeNotes=false" | grep -Eo '"downloadUrl":.*?[^\]",' | head -n 1 | cut -d \" -f 4 | sed -e 's/\\//g')
    appNewVersion=$(curl -s "https://api.renewedvision.com/v1/pro/upgrade?platform=macos&osVersion=12&appVersion=771&buildNumber=117899527&includeNotes=false" | grep -Eo '"version":.*?[^\]",' | head -n 1 | cut -d \" -f 4)
    expectedTeamID="97GAAZ6CPX"
    ;;
