capturewolf)
    name="CaptureWolf"
    type="appInDmgInZip"
    packageID="com.schubergphilis.capture-wolf"
    downloadURL=$(curl --silent --fail "https://api.github.com/repos/galadril/CaptureWolf/releases/latest" | awk -F '"' "/browser_download_url/ && /zip\"/ { print \$4; exit }")
    appNewVersion=$(grep -o -E '\d+\.\d+\.\d+' <<< $downloadURL | head -n 1)
    expectedTeamID="FN7VC8ZTQF"
    blockingProcesses=( "CaptureWolf" )
    ;;
