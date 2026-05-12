wisenetwave)
    name="Wisenet WAVE"
    type="dmg"
    releaseJSON=$(curl -fs "https://sync.wavevms.com/api/utils/downloads-releases")
    releasesChunk=$(echo "$releaseJSON" | grep -o '"releases":{.*')
    appNewVersion=$(getJSONValue "$releaseJSON" "releases.version")
    buildNumber=$(getJSONValue "$releaseJSON" "releases.buildNumber")
    updatesPrefix=$(getJSONValue "$releaseJSON" "updatesPrefix")
    if [[ $(arch) == "arm64" ]]; then
        installerPath=$(echo "$releasesChunk" | grep -o '"path":"[^"]*macos_arm64[^"]*\.dmg"' | head -1 | cut -d'"' -f4)
    else
        installerPath=$(echo "$releasesChunk" | grep -o '"path":"[^"]*macos_x64[^"]*\.dmg"' | head -1 | cut -d'"' -f4)
    fi
    downloadURL="${updatesPrefix}/${buildNumber}/${installerPath}"
    expectedTeamID="L6FE34GJWM"
    ;;
