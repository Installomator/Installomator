blackhole64ch)
    name="BlackHole"
    appName="BlackHole64ch.driver"
    type="pkg"
    packageID="audio.existential.BlackHole64ch"
    targetDir="/Library/Audio/Plug-Ins/HAL"
    downloadURL=$(getJSONValue "$(curl -fsL https://formulae.brew.sh/api/cask/blackhole-64ch.json)" "url")
    appNewVersion=$($(getJSONValue "$(curl -fsL https://formulae.brew.sh/api/cask/blackhole-64ch.json)" "version"))
    expectedTeamID="Q5C99V536K"
    blockingProcesses=( "coreaudiod" )
    ;;
