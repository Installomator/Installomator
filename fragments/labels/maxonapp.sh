maxonapp)
    name="Maxon"
    type="dmg"
    versionKey="CFBundleShortVersionString"
    appNewVersion="$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://www.maxon.net/en/try" | grep "Download Maxon App" -B3 | grep -Eo "202[0-9]+\.[0-9]+\.[0-9]+" | head -n 30 | sort -gru)"
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/website/macos/maxon/maxonapp/releases/${appNewVersion}/Maxon_App_${appNewVersion}_Mac.dmg"
    installerTool="Maxon App Installer.app"
    CLIInstaller="Maxon App Installer.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=(--mode unattended --unattendedmodeui none)
    expectedTeamID="4ZY22YGXQG"
    ;;
