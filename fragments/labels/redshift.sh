redshift)
    name="redshift"
    appName="Maxon Redshift Installer.app"
    blockingProcesses=( "Cinema 4D" )
    type="dmg"
    packageID="com.redshift3d.redshift"
    expectedTeamID="4ZY22YGXQG"
    downloadURL=$(curl -fsL https://www.maxon.net/en/downloads | grep -oE '[^"]*redshift[^"]*macos\.dmg' | head -1)
    appNewVersion=$(sed -n 's/.*redshift_\([^_]*\).*/\1/p' <<< "${downloadURL}")
    installerTool="Maxon Redshift Installer.app"
    CLIInstaller="Maxon Redshift Installer.app/Contents/MacOS/installbuilder.sh"
    # Customize --enable-components for other DCC integrations (Maya, Vectorworks, ZBrush)
    CLIArguments=( --mode unattended --enable-components Cinema4DGroup,PluginC4D2023,PluginC4D2024,PluginC4D2025,PluginC4D2026 )
    ;;
