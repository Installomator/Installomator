lmstudio)
    name="LM Studio"
    type="dmg"
    appNewVersion=$(curl -fsL "https://versions-prod.lmstudio.ai/update/darwin/arm64/latest" | plutil -extract version raw -)
    appBuild=$(curl -fsL "https://versions-prod.lmstudio.ai/update/darwin/arm64/${appNewVersion}" | plutil -extract build raw -)
    downloadURL="https://installers.lmstudio.ai/darwin/arm64/${appNewVersion}-${appBuild}/LM-Studio-${appNewVersion}-${appBuild}-arm64.dmg"
    expectedTeamID="D65G88RHWN"
    ;;
