mdmwatchdog)
    name="Addigy MDM Watchdog"
    type="pkg"
    packageID="com.addigy.mdm-watchdog"
    downloadURL="https://agents.addigy.com/tools/mdm-watchdog/latest/mdm-watchdog.pkg"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i location | cut -d '/' -f 6)"
    expectedTeamID="R5LEJ8Y242"
    blockingProcesses=( "NONE" )
    ;;
