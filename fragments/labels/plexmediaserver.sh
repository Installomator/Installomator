plexmediaserver)
    name="Plex Media Server"
    type="zip"
    plexDetails="$(curl -fs "https://plex.tv/api/downloads/5.json")"
    appNewVersion="$(cut -d'-' -f1 <<< "$(getJSONValue "$plexDetails" "computer.MacOS.version")")"
    downloadURL=$(getJSONValue "$plexDetails" "computer.MacOS.releases[0].url")
    versionKey="CFBundleShortVersionString"
    expectedTeamID="K4QJ56KR4A"
    ;;
