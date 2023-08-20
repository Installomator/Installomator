keyaccess)
    name="KeyAccess"
    type="pkg"
    downloadStore="$(curl -s "http://www.sassafras.com/client-download/" | tr '>' '\n')"
    downloadURL="$(echo "$downloadStore" | grep "https.*ksp-client.*pkg" | cut -d '"' -f 2)"
    appNewVersion="$(echo "$downloadStore" | grep "KeyAccess.*for Mac" | cut -d ' ' -f 2)"
    expectedTeamID="7Z2KSDFMVY"
    BLOCKING_PROCESS_ACTION=ignore
    blockingProcesses=( NONE )
    # Application is not installed in /Applications
    appName="Library/KeyAccess/KeyAccess.app"
    # Allowing for setting host as it is the only setting required for a fresh install.
    if [[ -n $keyaccessHost ]]; then
        defaults write /Library/Preferences/com.sassafras.KeyAccess host -string "${keyaccessHost}"
    fi
    ;;
