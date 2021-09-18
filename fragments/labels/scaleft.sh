scaleft)
    name="ScaleFT"
    type="pkg"
    downloadURL="https://dist.scaleft.com/client-tools/mac/latest/ScaleFT.pkg"
    appNewVersion=$(curl -sf "https://dist.scaleft.com/client-tools/mac/" | awk '/dir/{i++}i==2' | sed -nre 's/^[^0-9]*(([0-9]+\.)*[0-9]+).*/\1/p')
    expectedTeamID="HV2G9Z3RP5"
    blockingProcesses=( ScaleFT )
    ;;
