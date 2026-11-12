gentilhomme)
    name="Gentilhomme"
    type="dmg"
    gentilhommeFeed=$(curl -fsL "https://apps.perto.is/gentilhomme/gentilhomme.json")
    appNewVersion=$(getJSONValue "$gentilhommeFeed" "releases[0].version")
    downloadURL=$(getJSONValue "$gentilhommeFeed" "releases[0].url")
    expectedTeamID="V9R6UZHP7R"
    ;;
