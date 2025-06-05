cursorai)
    name="Cursor"
    type="dmg"
    downloadURL=$(curl -fsL "https://www.cursor.com/api/download?platform=darwin-universal&releaseTrack=stable" | grep -o '"downloadUrl":"[^"]*"' | sed 's/"downloadUrl":"\([^"]*\)"/\1/')
    expectedTeamID="VDXQ22DGB9"
    blockingProcesses=( "Cursor" )
    ;;
