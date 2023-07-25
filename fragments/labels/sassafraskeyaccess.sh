keyaccess)
    name="KeyAccess"
    type="pkg"
    downloadPAGE="http://www.sassafras.com/client-download/"
    downloadURL="$(curl -s "$downloadPAGE" | tr '>' '\n' | grep "https.*ksp-client.*pkg" | cut -d '"' -f 2)"
    appNewVersion="$(curl -s "$downloadPAGE" | tr '>' '\n' | grep "KeyAccess.*for Mac" | cut -d ' ' -f 2)"
    expectedTeamID="7Z2KSDFMVY"
    blockingProcesses=( NONE )
    # Application is not installed in /Applications
    targetDir="/Library/KeyAccess"
    ;;
