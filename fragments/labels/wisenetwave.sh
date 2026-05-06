wisenetwave)
    if [[ $(/usr/bin/arch) != "arm64" ]]; then
        cleanupAndExit 76 "wisenetwave is only available for Apple Silicon (arm64)" ERROR
    fi
    name="Wisenet Wave"
    type="dmg"
    releaseData=$(curl -fs "https://sync.wavevms.com/api/utils/downloads-releases")
    releasesChunk=$(echo "$releaseData" | grep -o '"releases":{.*')
    appNewVersion=$(echo "$releasesChunk" | grep -o '"version":"[0-9.]*"' | head -1 | cut -d'"' -f4)
    buildNumber=$(echo "$releasesChunk" | grep -o '"buildNumber":"[0-9]*"' | head -1 | cut -d'"' -f4)
    fileName=$(echo "$releasesChunk" | grep -o '"fileName":"wave-client-[^"]*-macos_arm64\.dmg"' | head -1 | cut -d'"' -f4)
    downloadURL="https://updates.wavevms.com/hanwha/${buildNumber}/macos/${fileName}"
    appName="Wisenet WAVE.app"
    blockingProcesses=( "Wisenet WAVE" )
    expectedTeamID="L6FE34GJWM"
    ;;
