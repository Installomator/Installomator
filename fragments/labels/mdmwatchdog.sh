mdmwatchdog)
    name="mdm-watchdog"
    # Addigy (a MDM provider) has release a binary to check certain MDM bindings, softwareupdate getting stuck etc.
    # Read more here: https://addigy.com/mdm-watchdog/
    type="pkg"
    #packageID="com.addigy.mdm-watchdog" # packageID version is 0 for version 5
    downloadURL="$(curl -fs "https://addigy.com/mdm-watchdog/" | grep Download | grep -Eo "https.*mdm-watchdog.pkg")"
    appCustomVersion(){ /usr/local/bin/mdm-watchdog -version }
    appNewVersion="$(echo "$downloadURL" | cut -d "/" -f6)"
    expectedTeamID="R5LEJ8Y242"
    ;;
