wisenetwave)
    # Wisenet Wave VMS Client (Hanwha Vision)
    # Download page: https://sync.wavevms.com/download/macos
    # Versions API: https://sync.wavevms.com/api/utils/downloads-releases
    # Only targeting macos_arm64 client build; x86_64 exists but is not needed.

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
