adobecreativeclouddesktop)
    name="Adobe Creative Cloud"
    appName="Creative Cloud.app"
    type="dmg"
    if pgrep -q "Adobe Installer"; then
        cleanupAndExit 75 "Adobe Installer is running; Adobe Creative Cloud cannot be updated." WARN
    fi
    if [[ $(arch) == "arm64" ]]; then
        adobeArch="macarm64"
    else
        adobeArch="osx10"
    fi
    adobeConfig=$(curl -fsSL "https://ffc-static-cdn.oobesaas.adobe.com/init/v1/$adobeArch/ccdConfig.json") || cleanupAndExit 14 "Could not retrieve Adobe Creative Cloud update configuration." ERROR
    appNewVersion=$(getJSONValue "$(getJSONValue "$adobeConfig" ".features['feature-response']['feature-entry'].find(item => item.id == 'ccd.fw.update.greenline.latest').data")" "version")
    [[ -n "$appNewVersion" ]] || cleanupAndExit 14 "Could not determine Adobe Creative Cloud version." ERROR
    IFS='.' read -r major minor patch build <<< "$appNewVersion"
    downloadURL="https://ccmdls.adobe.com/AdobeProducts/StandaloneBuilds/ACCC/ESD/$major.$minor.$patch/$build/$adobeArch/ACCCx${appNewVersion//./_}.dmg"
    appCustomVersion() { sqlite3 "/Library/Application Support/Adobe/Adobe Desktop Common/pim.db" "SELECT value FROM pim_meta WHERE key='application_version';" 2>/dev/null; }
    targetDir="/Applications/Utilities/Adobe Creative Cloud/ACC/"
    installerTool="Install.app"
    CLIInstaller="Install.app/Contents/MacOS/Install"
    CLIArguments=(--mode=silent)
    expectedTeamID="JQ525L2MZD"
    blockingProcesses=( "Creative Cloud" )
    ;;
