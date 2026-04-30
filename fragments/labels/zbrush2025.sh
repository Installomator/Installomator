zbrush2025)
	#credit pmex for the building the framework used for Maxon apps
	name="ZBrush"
    type="dmg"
    appCustomVersion(){
    defaults read "/Applications/Maxon ZBrush 2025/ZBrush.app/Contents/Info.plist" CFBundleVersion | grep -Eo "2025+\.[0-9]+"
    }
	downloadURL=$(curl -fsL https://www.maxon.net/en/downloads | grep -oE '[^"]*zbrush[^"]*\.dmg' | grep -v "windows.net" | sort -r | head -1)
	appNewVersion=$(sed -n 's/.*ZBrush_\([^_]*\).*/\1/p' <<< "${downloadURL}")
    targetDir="/Applications/Maxon ZBrush 2025"
    installerTool="ZBrush_${appNewVersion}_Installer.app"
    CLIInstaller="ZBrush_${appNewVersion}_Installer.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=(--mode unattended --unattendedmodeui none)
    expectedTeamID="4ZY22YGXQG"
    ;;

