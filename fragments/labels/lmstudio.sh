lmstudio)
    name="LM Studio"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        versionData=$(curl -fsL "https://versions-prod.lmstudio.ai/update/darwin/arm64/latest")
        appVersion=$(echo "$versionData" | sed -n 's/.*"version":"\([^"]*\)".*/\1/p')
        appBuild=$(echo "$versionData" | sed -n 's/.*"build":"\([^"]*\)".*/\1/p')
        downloadVersion="${appVersion}-${appBuild}"
        downloadURL="https://installers.lmstudio.ai/darwin/arm64/${downloadVersion}/LM-Studio-${downloadVersion}-arm64.dmg"
        appNewVersion="${appVersion}+${appBuild}"
    else
        printlog "LM Studio is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "LM Studio requires Apple Silicon" ERROR
    fi
    expectedTeamID="D65G88RHWN"
    ;;
