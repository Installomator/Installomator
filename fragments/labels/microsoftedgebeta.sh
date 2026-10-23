microsoftedgebeta)
    name="Microsoft Edge Beta"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2099618"
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/MicrosoftEdgeBeta.*pkg" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    expectedTeamID="UBF8T346G9"
    ;;
