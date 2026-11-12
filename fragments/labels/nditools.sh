nditools)
    name="NDI Tools"
    type="pkg"
    appName="NDI Access Manager.app"
    ndiToolsHTML=$(curl -fsL "https://ndi.video/tools/")
    downloadURL=$(echo "$ndiToolsHTML" | grep -oE 'https://downloads\.ndi\.tv/Tools/[^"]+\.pkg' | head -1)
    appNewVersion=$(echo "$ndiToolsHTML" | grep -oE 'Version [0-9]+(\.[0-9]+)+' | head -1 | awk '{print $2}')
    expectedTeamID="W8U66ET244"
    blockingProcesses=( "NDI Access Manager" "NDI Discovery" "NDI Launcher" "NDI Router" "NDI Scan Converter" "NDI Test Patterns" "NDI Video Monitor" "NDI Virtual Input" )
    ;;
