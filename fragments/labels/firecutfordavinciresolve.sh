firecutfordavinciresolve)
    name="Firecut for DaVinci Resolve"
    type="dmg"
    downloadURL="$(curl -fsIL https://firecut.ai/downloads/davinci/apple_silicon/ | grep -i ^location | awk '{print $2}' | tr -d '\r')"
    appNewVersion=$(echo $downloadURL | awk -F "." '{print$7}' | sed 's/v//' | sed 's/_/./g')
    expectedTeamID="7ASRSVAEMS"
    blockingProcesses=( "Resolve" )
    ;;
