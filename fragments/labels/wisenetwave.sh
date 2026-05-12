wisenetwave)
    name="Wisenet Wave"
    type="dmg"
    releaseJSON=$(curl -fs "https://sync.wavevms.com/api/utils/downloads-releases")
    appNewVersion=$(osascript -l JavaScript \
        -e "const data = JSON.parse(\`${releaseJSON}\`)" \
        -e "data.releases.version")
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(osascript -l JavaScript \
            -e "const data = JSON.parse(\`${releaseJSON}\`)" \
            -e "const r = data.releases" \
            -e "const i = r.installers.find(i => i.platform === 'macos_arm64' && i.appType === 'client')" \
            -e "data.updatesPrefix + '/' + r.buildNumber + '/' + i.path")
    else
        downloadURL=$(osascript -l JavaScript \
            -e "const data = JSON.parse(\`${releaseJSON}\`)" \
            -e "const r = data.releases" \
            -e "const i = r.installers.find(i => i.platform === 'macos_x64' && i.appType === 'client')" \
            -e "data.updatesPrefix + '/' + r.buildNumber + '/' + i.path")
    fi
    appName="Wisenet WAVE.app"
    blockingProcesses=( "Wisenet WAVE" )
    expectedTeamID="L6FE34GJWM"
    ;;
