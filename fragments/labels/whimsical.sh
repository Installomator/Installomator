whimsical)
    name="Whimsical"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://desktop.whimsical.com/mac/dmg/arm64"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://desktop.whimsical.app/mac/dmg/x64"
    fi
    appNewVersion=$(curl -sIkL $downloadURL | sed -r '/filename=/!d;s/.*filename=(.*)$/\1/' | awk '{print $2}')
    expectedTeamID="2N6497CB83"
    versionKey="CFBundleShortVersionString"
    appName="Whimsical.app"
    blockingProcesses=( "Whimsical" )
    ;;
    
