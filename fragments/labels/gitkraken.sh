gitkraken)
    name="gitkraken"
    type="dmg"
    appNewVersion=$( curl -sfL https://www.gitkraken.com/download | grep -o 'Latest release: [0-9.]*' | grep -o '[0-9.]*' )
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://release.gitkraken.com/darwin-arm64/installGitKraken.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://release.gitkraken.com/darwin/installGitKraken.dmg"
    fi
    expectedTeamID="T7QVVUTZQ8"
    blockingProcesses=( "GitKraken" )
    ;;
