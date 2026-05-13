keyaccess)
    name="KeyAccess"
    type="pkg"
    downloadStore="$(curl -sL "http://www.sassafras.com/client-download/" | tr '>' '\n')"
    downloadURL="$(echo "$downloadStore" | grep "https.*ksp-client.*pkg" | cut -d '"' -f 2)"
    appNewVersion="$(echo "$downloadStore" | grep "KeyAccess.*for Mac" | cut -d ' ' -f 2)"
    expectedTeamID="7Z2KSDFMVY"
    BLOCKING_PROCESS_ACTION=ignore
    blockingProcesses=( NONE )
    # Application is not installed in /Applications
    appName="Library/KeyAccess/KeyAccess.app"
    # Don't forget to at least set the host, or nothing will happen.
    # defaults write /Library/Preferences/com.sassafras.KeyAccess host -string "host.name"
    ;;
