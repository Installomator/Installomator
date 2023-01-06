ringcentralapp)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="RingCentral"
    type="pkg"
    if [[ $(arch) != "i386" ]]; then
        downloadURL="https://app.ringcentral.com/download/RingCentral-arm64.pkg"
    else
        downloadURL="https://app.ringcentral.com/download/RingCentral.pkg"
    fi
    expectedTeamID="M932RC5J66"
    blockingProcesses=( "RingCentral" )
    ;;
