cursorai)
    name="Cursor"
    type="dmg"
    downloadURL=$(curl -fsL "https://www.cursor.com/download" | grep -Eo 'https://[^"]*darwin/universal[^"]*\.dmg' | head -n 1)
    expectedTeamID="VDXQ22DGB9"
    blockingProcesses=( "Cursor" )
    versionKey="CFBundleVersion"
    ;;
