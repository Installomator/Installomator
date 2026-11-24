maxonapp)
    name="Maxon"
    type="zip"
    versionKey="CFBundleShortVersionString"
    appNewVersion="$(curl -s "https://packages.maxon.net/manifests?platform=macos&org=maxon&type=products&family=fuse" | tr '{' '\n' | tr ',' '\n' | tr '}' '\n' | grep "version" | awk -F'"' '{print $4}' | sort -Vr | head -n 1)"
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/maxon/maxonapp/releases/${appNewVersion}/Maxon_App_${appNewVersion}_Mac.zip"
    installerTool="Maxon_App_${appNewVersion}_Mac.app"
    CLIInstaller="Maxon_App_${appNewVersion}_Mac.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=(--mode unattended --unattendedmodeui none)
    expectedTeamID="4ZY22YGXQG"
    ;;
