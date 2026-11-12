mimicarecorder)
    name="Mimica Recorder"
    type="pkg"
    packageID="com.mimica.recorder"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://app.mimica.ai/events/recordersetup/mimica-macos/com.mimica.recorder-osx-Setup.pkg"
        appNewVersion=$(getJSONValue "$(curl -fsL "https://app.mimica.ai/events/recordersetup/mimica-macos/releases.osx.json")" "Assets[0].Version")
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://app.mimica.ai/events/recordersetup/mimica-macos/com.mimica.recorder-osx-x64-Setup.pkg"
        appNewVersion=$(getJSONValue "$(curl -fsL "https://app.mimica.ai/events/recordersetup/mimica-macos/releases.osx-x64.json")" "Assets[0].Version")
    fi
    expectedTeamID="24R79RZJPD"
    blockingProcesses=( "Mimica.Recorder.Mac" )
    ;;
