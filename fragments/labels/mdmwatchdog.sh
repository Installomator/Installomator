mdmwatchdog)
    name="mdm-watchdog"
    # Addigy (a MDM provider) has release a binary to check certain MDM bindings, softwareupdate getting stuck etc.
    # Read more here: https://addigy.com/mdm-watchdog/
    type="pkg"
    packageID="com.addigy.mdm-watchdog"
    downloadURL="https://agents.addigy.com/tools/mdm-watchdog/latest/mdm-watchdog.pkg"
    #appCustomVersion(){ /usr/local/bin/mdm-watchdog -version }
    appNewVersion="$(curl -fsIL "$downloadURL" | grep -i ^location | cut -w -f2 | cut -d "/" -f6)"
    expectedTeamID="R5LEJ8Y242"
    blockingProcesses=( NONE )
    ;;
