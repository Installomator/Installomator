thinlincclient)
    name="ThinLinc Client"
    type="dmg"
    jsonFeed=$(curl -fsL "https://formulae.brew.sh/api/cask/thinlinc-client.json")
    appNewVersion=$(getJSONValue "$jsonFeed" "version" | awk -F '_' '{ print $1 }')
    downloadURL=$(getJSONValue "$jsonFeed" "url")
    expectedTeamID="PHUT6TWL4H"
    ;;
