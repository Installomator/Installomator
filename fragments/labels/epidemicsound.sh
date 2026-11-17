epidemicsound)
    name="Epidemic Sound"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://storage.googleapis.com/es-plugin-builds/desktop/darwin/arm64/latest/Epidemic%20Sound-arm64.dmg"
        epidemicsoundJSON=$(curl -fsL "https://storage.googleapis.com/es-plugin-builds/desktop/darwin/arm64/RELEASES.json")
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://storage.googleapis.com/es-plugin-builds/desktop/darwin/x64/latest/Epidemic%20Sound-x64.dmg"
        epidemicsoundJSON=$(curl -fsL "https://storage.googleapis.com/es-plugin-builds/desktop/darwin/x64/RELEASES.json")
    fi
    appNewVersion=$(getJSONValue "$epidemicsoundJSON" "currentRelease")
    expectedTeamID="LE95XJ5KXM"
    ;;
