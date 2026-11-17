torbrowser)
    name="Tor Browser"
    type="dmg"
    torbrowserJSON=$(curl -fsL "https://aus1.torproject.org/torbrowser/update_3/release/download-macos.json")
    downloadURL=$(getJSONValue "$torbrowserJSON" "binary")
    appNewVersion=$(getJSONValue "$torbrowserJSON" "version")
    expectedTeamID="MADPSAYN6T"
    ;;
