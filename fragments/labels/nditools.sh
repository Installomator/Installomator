nditools)
    name="NDI Tools"
    type="pkg"
    appName="NDI Access Manager.app"
    downloadURL="https://downloads.ndi.tv/Tools/NDIToolsInstaller.pkg"
    appNewVersion=$(getJSONValue \
        "$(curl -fsL "https://downloads.ndi.tv/Tools/ndi_tools_osx_current_version.json")" \
        "version")
    expectedTeamID="W8U66ET244"
    blockingProcesses=( "NDI Access Manager" "NDI Discovery" "NDI Launcher" "NDI Router" "NDI Scan Converter" "NDI Test Patterns" "NDI Video Monitor" "NDI Virtual Input" )
    ;;
