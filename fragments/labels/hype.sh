hype)
    name="Hype4"
    type="dmg"
    packageID="com.tumult.Hype4"
    downloadURL="https://static.tumult.com/hype/download/Hype.dmg"
    appNewVersion=$( curl -fsL https://tumult.com/hype/download/all/ | grep Ongoing | awk -F '<' '{print $4}' | sed 's/[^0-9.]//g' )
    expectedTeamID="8J356DM772"
    blockingProcesses=( NONE )
    ;;
