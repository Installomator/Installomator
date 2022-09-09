coderunner)
    name="CodeRunner"
    type="zip"
    downloadURL="https://coderunnerapp.com/download"
    appNewVersion=$(curl -fsIL ${downloadURL} | grep -i "^location" | cut -d " " -f2 | sed -E 's/.*CodeRunner-([0-9.]*).zip/\1/')
    expectedTeamID="R4GD98AJF9"
    ;;
