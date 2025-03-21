cursorai)
    name="Cursor"
    type="dmg"
    appNewVersion=$(curl -sL "https://www.cursor.com/changelog" | xmllint --html -xpath "//article[1]" - 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)
    downloadURL=$(curl -fsL "https://www.cursor.com/api/download?platform=darwin-universal&releaseTrack=stable" | grep -o '"downloadUrl":"[^"]*"' | sed 's/"downloadUrl":"\([^"]*\)"/\1/')
    expectedTeamID="VDXQ22DGB9"
    blockingProcesses=( "Cursor" )
    ;;
