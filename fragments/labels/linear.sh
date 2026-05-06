linear)
    name="Linear"
    type="dmg"
    downloadURL="https://releases.linear.app/mac"
    appNewVersion=$(curl -sIkL $downloadURL | sed -r '/filename=/!d;s/.*filename=(.*)$/\1/' | awk -F'-' '{print $2}')
    expectedTeamID="7VZ2S3V9RV"
    versionKey="CFBundleShortVersionString"
    appName="Linear.app"
    blockingProcesses=( "Linear" )
    ;;
    
