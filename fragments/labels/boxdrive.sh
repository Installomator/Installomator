boxdrive)
    name="Box"
    type="pkg"
    jsonFeed=$(curl -fsL "https://cdn07.boxcdn.net/Autoupdate6.json")
    macDetails=$(getJSONValue "$jsonFeed" "mac.enterprise")
    appNewVersion=$(getJSONValue "$macDetails" "version")
    downloadURL=$(getJSONValue "$macDetails" '["download-url"]')
    expectedTeamID="M683GB7CPW"
    ;;
