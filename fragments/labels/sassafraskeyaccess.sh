keyaccess)
    name="KeyAccess"
    type="pkg"
    downloadStore="$(curl -s "http://www.sassafras.com/client-download/" | tr '>' '\n')"
    downloadURL="$(echo "$downloadStore" | grep "https.*ksp-client.*pkg" | cut -d '"' -f 2)"
    appNewVersion="$(echo "$downloadStore" | grep "KeyAccess.*for Mac" | cut -d ' ' -f 2)"
    expectedTeamID="7Z2KSDFMVY"
    blockingProcesses=( NONE )
    # Application is not installed in /Applications
    targetDir="/Library/KeyAccess"
    ;;
