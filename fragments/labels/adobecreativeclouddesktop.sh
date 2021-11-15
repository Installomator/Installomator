adobecreativeclouddesktop)
    name="Adobe Creative Cloud"
    #appName="Install.app"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fs "https://helpx.adobe.com/download-install/kb/creative-cloud-desktop-app-download.html" | grep -o "https*.*macarm64.*dmg" | cut -d '"' -f1 | head -1)
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fs "https://helpx.adobe.com/download-install/kb/creative-cloud-desktop-app-download.html" | grep -o "https*.*osx10.*dmg" | cut -d '"' -f1 | head -1)
    fi
    #downloadURL=$(curl -fs "https://helpx.adobe.com/download-install/kb/creative-cloud-desktop-app-download.html" | grep -o "https*.*dmg" | head -1)
    appNewVersion=$(curl -fs "https://helpx.adobe.com/creative-cloud/release-note/cc-release-notes.html" | grep "mandatory" | head -1 | grep -o "Version *.* released" | cut -d " " -f2)
    installerTool="Install.app"
    CLIInstaller="Install.app/Contents/MacOS/Install"
    CLIArguments=(--mode=silent)
    expectedTeamID="JQ525L2MZD"
    Company="Adobe"
    ;;
