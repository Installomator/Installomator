mimicarecorder)
    name="Mimica Recorder"
    type="pkg"
    packageID="com.mimica.recorder"
    downloadURL="https://app.mimica.ai/events/recordersetup/mimica-macos/com.mimica.recorder-osx-Setup.pkg"
    appNewVersion=$(getJSONValue "$(curl -fsL "https://app.mimica.ai/events/recordersetup/mimica-macos/releases.osx.json")" "Assets[0].Version")
    expectedTeamID="24R79RZJPD"
    blockingProcesses=( "Mimica.Recorder.Mac" )
    ;;
