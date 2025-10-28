adobecreativeclouddesktop)
    name="Adobe Creative Cloud"
    appName="Creative Cloud.app"
    type="dmg"
    if pgrep -q "Adobe Installer"; then
        printlog "Adobe Installer is running, not a good time to update." WARN
        printlog "################## End $APPLICATION \n\n" INFO
        exit 75
    fi
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL=$(curl -fs "https://helpx.adobe.com/in/download-install/apps/download-install-apps/creative-cloud-apps/download-creative-cloud-desktop-app-using-direct-links.html" | grep -o 'https.*macarm64.*dmg' | head -1 | cut -d '"' -f1)
    else
        downloadURL=$(curl -fs "https://helpx.adobe.com/in/download-install/apps/download-install-apps/creative-cloud-apps/download-creative-cloud-desktop-app-using-direct-links.html" | grep -o 'https.*osx10.*dmg' | head -1 | cut -d '"' -f1)
    fi
    #appNewVersion=$(curl -fs "https://helpx.adobe.com/creative-cloud/release-note/cc-release-notes.html" | grep "mandatory" | head -1 | grep -o "Version *.* released" | cut -d " " -f2)
    appNewVersion=$(echo $downloadURL | grep -o '[^x]*$' | cut -d '.' -f 1 | sed 's/_/\./g')
    targetDir="/Applications/Utilities/Adobe Creative Cloud/ACC/"
    installerTool="Install.app"
    CLIInstaller="Install.app/Contents/MacOS/Install"
    CLIArguments=(--mode=silent)
    expectedTeamID="JQ525L2MZD"
    blockingProcesses=( "Creative Cloud" )
    Company="Adobe"
    ;;
