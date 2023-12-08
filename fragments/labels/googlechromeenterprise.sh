googlechromeenterprise)
    name="Google Chrome"
    type="pkg"
    downloadURL="https://dl.google.com/dl/chrome/mac/universal/stable/gcem/GoogleChrome.pkg"
    # omahaproxy is permanently dead; so we need to use the google api service now
    if [[ $(arch) == "arm64" ]]; then
    # we pick the second name because the first is a limited rollout; the secon name is the wider distributed package
        appNewVersion=$(curl -s https://versionhistory.googleapis.com/v1/chrome/platforms/mac_arm64/channels/stable/versions | grep name | head -n 1 | tail -n 1 | cut -d \" -f 4 | cut -d / -f 7)
    elif [[ $(arch) == "i386" ]]; then
    # we pick the second name because the first is a limited rollout; the secon name is the wider distributed package
        appNewVersion=$(curl -s https://versionhistory.googleapis.com/v1/chrome/platforms/mac/channels/stable/versions | grep name | head -n 1 | tail -n 1 | cut -d \" -f 4 | cut -d / -f 7)
    fi
    expectedTeamID="EQHXZ8M8AV"
    updateTool="/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/Resources/GoogleSoftwareUpdateAgent.app/Contents/MacOS/GoogleSoftwareUpdateAgent"
    updateToolArguments=( -runMode oneshot -userInitiated YES )
    updateToolRunAsCurrentUser=1
    ;;
