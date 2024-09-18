maxonapp)
    name="Maxon"
    type="dmg"
    versionKey="CFBundleShortVersionString"
    appNewVersion="$(curl -s "https://packages.maxon.net/manifests?platform=macos&org=maxon&type=products&family=fuse" | tr '{' '\n' | tr ',' '\n' | tr '}' '\n' | grep "version" | awk -F'"' '{print $4}' | sort -gr | head -n 1)"
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/website/macos/maxon/maxonapp/releases/${appNewVersion}/Maxon_App_${appNewVersion}_Mac.dmg"
    installerTool="Maxon App Installer.app"
    CLIInstaller="Maxon App Installer.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=(--mode unattended --unattendedmodeui none)
    expectedTeamID="4ZY22YGXQG"
    ;;
