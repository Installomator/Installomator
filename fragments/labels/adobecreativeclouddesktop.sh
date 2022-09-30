adobecreativeclouddesktop)
    name="Adobe Creative Cloud"
    type="dmg"
    if pgrep -q "Adobe Installer"; then
        printlog "Adobe Installer is running, not a good time to update." WARN
        printlog "################## End $APPLICATION \n\n" INFO
        exit 75
    fi
    adobeurl="https://helpx.adobe.com/download-install/kb/creative-cloud-desktop-app-download.html"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fs "$adobeurl" | xmllint -html -xpath "string(//a[contains(@href,'macarm64')][contains(text(),'Download')]/@href)" - 2> /dev/null)
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fs "$adobeurl" | xmllint -html -xpath "string(//a[contains(@href,'osx10')][contains(text(),'Download')]/@href)" - 2> /dev/null)
    fi
    appNewVersion=$(curl -fs "https://helpx.adobe.com/creative-cloud/release-note/cc-release-notes.html" | grep "mandatory" | head -1 | grep -o "Version *.* released" | cut -d " " -f2)
    #appNewVersion=$(echo "$downloadURL" | grep -o '[^x]*$' | cut -d '.' -f 1 | sed 's/_/\./g')
    installerTool="Install.app"
    CLIInstaller="Install.app/Contents/MacOS/Install"
    CLIArguments=(--mode=silent)
    expectedTeamID="JQ525L2MZD"
    Company="Adobe"
    ;;
