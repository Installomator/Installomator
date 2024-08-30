ecosiabrowser)
    name="Ecosia Browser"
    type="dmg"
 	downloadURL=$(getJSONValue "$(curl -fsL 'https://ams.ecosia-browser.net/api/getLatest/144548e4-670e-46ef-be30-8d14ad305f19/mac/?update=false&channelprofilename=PROD&arch=x64')" '.LocationUri')
    appNewVersion=$(getJSONValue "$(curl -fsL 'https://ams.ecosia-browser.net/api/getLatest/144548e4-670e-46ef-be30-8d14ad305f19/mac/?update=false&channelprofilename=PROD&arch=x64')" '.Version')
    expectedTeamID="33YMRSYD2L"
    ;;
