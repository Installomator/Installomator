redshift)
    name="redshift"
    blockingProcesses=( "Cinema 4D" )
    type="dmg"
    expectedTeamID="4ZY22YGXQG"
    downloadURL=$(curl -fsL https://www.maxon.net/en/downloads | grep -oE '[^"]*redshift[^"]*macos\.dmg' | head -1)
    appNewVersion=$(sed -n 's/.*redshift_\([^_]*\).*/\1/p' <<< "${downloadURL}")
    appCustomVersion() {/usr/bin/defaults read "/Applications/Maxon Redshift 2026/uninstall.app/Contents/Info.plist" CFBundleVersion }
    installerTool="Maxon Redshift Installer.app"
    CLIInstaller="Maxon Redshift Installer.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=( --mode unattended --enable-components Cinema4DGroup,PluginC4D2023,PluginC4D2024,PluginC4D2025,PluginC4D2026 )
    ;;
