amazonchime)
    # credit: @dvsjr macadmins slack
    name="Amazon Chime"
    type="dmg"
    downloadURL="https://clients.chime.aws/mac/latest"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z.\-]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="94KV3E626L"
    ;;
