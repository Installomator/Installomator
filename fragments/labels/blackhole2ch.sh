blackhole2ch)
    name="BlackHole"
    appName="BlackHole2ch.driver"
    type="pkg"
    packageID="audio.existential.BlackHole2ch"
    targetDir="/Library/Audio/Plug-Ins/HAL"
    downloadURL=$(getJSONValue "$(curl -fsL https://formulae.brew.sh/api/cask/blackhole-2ch.json)" "url")
    appNewVersion=$($(getJSONValue "$(curl -fsL https://formulae.brew.sh/api/cask/blackhole-2ch.json)" "version"))
    expectedTeamID="Q5C99V536K"
    blockingProcesses=( "coreaudiod" )
    ;;
