itsycal)
    name="Itsycal"
    type="zip"
    downloadURL="https://itsycal.s3.amazonaws.com/Itsycal.zip"
    appNewVersion=$( curl -fsL https://www.mowglii.com/itsycal/versionhistory.html |grep -m1 'id="0' |awk -F '"' '{print $2}' )
    blockingProcesses=( "Itsycal" )
    expectedTeamID="HFT3T55WND"
    ;;
