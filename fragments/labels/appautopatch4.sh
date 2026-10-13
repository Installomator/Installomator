appautopatch4)
    name="App Auto-Patch"
    type="pkg"
    aapDetails="$(curl -fsL "https://downloads.appautopatch.app/latest.json")"
    appNewVersion="$(getJSONValue "$aapDetails" "build")"
    versionKey="CFBundleVersion"
    downloadURL="$(getJSONValue "$aapDetails" "url")"
    expectedTeamID="6GBSVT64FS"
    blockingProcesses=( NONE )
    ;;
