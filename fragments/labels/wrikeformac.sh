wrikeformac)
    name="Wrike"
    appName="Wrike for Mac.app"
    type="dmg"
    wrikeJSON=$(curl -fsL "https://www.wrike.com/frontend/electron-app/changelog.json")
    appNewVersion=$(getJSONValue "$wrikeJSON" "[0].version")
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://dl.wrike.com/download/WrikeDesktopApp_ARM.v${appNewVersion}.dmg"
    else
        downloadURL="https://dl.wrike.com/download/WrikeDesktopApp.v${appNewVersion}.dmg"
    fi
    expectedTeamID="BD3YL53XT4"
    ;;
