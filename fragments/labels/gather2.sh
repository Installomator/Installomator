gather2)
    name="Gather"
    type="dmg"
    appNewVersion=$(getJSONValue "$(curl -fsL 'https://api.v2.gather.town/api/v2/releases/desktop/latest')" "version")
    downloadURL="https://api.v2.gather.town/api/v2/releases/latest/macos/v2"
    expectedTeamID="W28UKP642P"
    ;;

