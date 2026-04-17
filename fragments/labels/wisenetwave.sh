wisenetwave)
    # Wisenet Wave VMS Client (Hanwha Vision)
    # Download page: https://sync.wavevms.com/download/macos
    # Versions API: https://sync.wavevms.com/api/utils/downloads-releases
    # Only targeting macos_arm64 client build; x86_64 exists but is not needed.

    name="Wisenet Wave"
    type="dmg"
    releaseData=$(curl -fs "https://sync.wavevms.com/api/utils/downloads-releases")
    appNewVersion=$(echo "$releaseData" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['releases']['version'])")
    buildNumber=$(echo "$releaseData" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['releases']['buildNumber'])")
    fileName=$(echo "$releaseData" | python3 -c "import json,sys; d=json.load(sys.stdin); print(next(i['fileName'] for i in d['releases']['installers'] if i['platform']=='macos_arm64' and i['appType']=='client'))")
    downloadURL="https://updates.wavevms.com/hanwha/${buildNumber}/macos/${fileName}"
    appName="Wisenet WAVE.app"
    blockingProcesses=( "Wisenet WAVE" )
    expectedTeamID="L6FE34GJWM"
    ;;
