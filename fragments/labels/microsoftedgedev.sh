microsoftedgedev)
    name="Microsoft Edge Dev"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2099619"
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/MicrosoftEdgeDev.*pkg" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    expectedTeamID="UBF8T346G9"
    ;;
