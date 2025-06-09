cursorai)
    name="Cursor"
    type="dmg"
    updateFeed=$(curl -fsL  "https://www.cursor.com/api/download?platform=darwin-universal&releaseTrack=stable")
    appNewVersion=$(getJSONValue "${updateFeed}" "version")
    downloadURL=$(getJSONValue "${updateFeed}" "downloadUrl")
    expectedTeamID="VDXQ22DGB9"
    blockingProcesses=( "Cursor" )
    ;;
