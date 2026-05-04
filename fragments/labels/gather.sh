gather|\
gathertown)
    name="Gather"
    type="dmg"
    appNewVersion=$(getJSONValue "$(curl -fsL 'https://api.gather.town/api/v2/releases/desktop/latest')" "version")
    downloadURL="https://api.v2.gather.town/api/v2/releases/latest/macos/v1"
    expectedTeamID="W28UKP642P"
    ;;

