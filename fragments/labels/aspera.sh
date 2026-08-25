aspera|\
ibmaspera)
    name="IBM Aspera"
    type="pkg"
    appNewVersion=$(curl -fsL https://downloads.ibmaspera.com/downloads/desktop/latest/stable/latest.json | jq -r '.entries.[] | select(.platform == "macos") | .version')
    downloadURL=$(curl -fsL https://downloads.ibmaspera.com/downloads/desktop/latest/stable/latest.json | jq -r '.entries.[] | select(.platform == "macos") | .url')
    expectedTeamID="PETKK2G752"
    ;;
