firecutfordavinciresolve)
    name="FireCut for DaVinci Resolve"
    type="dmg"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL="$(curl -fsIL https://firecut.ai/downloads/davinci/apple_silicon/ | grep -i ^location | awk '{print $2}' | tr -d '\r' | grep "https://" | tail -1)"
    else
        downloadURL="$(curl -fsIL https://firecut.ai/downloads/davinci/apple_intel/ | grep -i ^location | awk '{print $2}' | tr -d '\r' | grep "https://" | tail -1)"
    if
    appNewVersion=$(echo $downloadURL | awk -F "." '{print$7}' | sed 's/v//' | sed 's/_/./g')
    expectedTeamID="7ASRSVAEMS"
    blockingProcesses=( "Resolve" )
    ;;
