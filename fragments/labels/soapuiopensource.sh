soapuiopensource)
    name="SoapUI"
    type="dmg"
    downloadURL="$(curl -fsL "https://github.com/SmartBear/soapui/releases/latest" | grep -m 1 -o 'href=".*\.dmg".*' | cut -d '"' -f 2)"
    appNewVersion="$(versionFromGit SmartBear soapui)"
    appCustomVersion() {
        while IFS= read -r line; do
            soapUIApps+=("$line")
        done < <(ls -d ${targetDir}/* | grep -E "SoapUI-.*\.app")

        if [ -e "${soapUIApps[-1]}" ]; then
            defaults read "${soapUIApps[-1]}/Contents/Info.plist" CFBundleShortVersionString
        fi
    }
    installerTool="SoapUI ${appNewVersion} Installer.app"
    CLIInstaller="${installerTool}/Contents/MacOS/JavaApplicationStub"
    CLIArguments=(-q)
    expectedTeamID="HVA5GNL2LF"
    ;;
