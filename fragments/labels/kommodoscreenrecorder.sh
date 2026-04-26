kommodo|\
kommodoscreenrecorder)
    name="Kommodo Screen Recorder"
    type="pkg"
    archiveName="KommodoScreenRecorder.pkg"
    if [[ $(arch) == "arm64" ]]; then
        appNewVersion=$(curl -fs "https://api.prod.komododecks.com/api/v2/releases/arm64/latest-mac.yml" | awk '/^version:/ {print $2}')
        downloadURL="https://releases.komododecks.com/prod/electron/${appNewVersion}/kommodo-screen-recorder-${appNewVersion}-arm.pkg"
    elif [[ $(arch) == "i386" ]]; then
        appNewVersion=$(curl -fs "https://api.prod.komododecks.com/api/v2/releases/x64/latest-mac.yml" | awk '/^version:/ {print $2}')
        downloadURL="https://releases.komododecks.com/prod/electron/${appNewVersion}/kommodo-screen-recorder-${appNewVersion}-intel.pkg"
    fi
    expectedTeamID="3M6U87VP9P"
    ;;
