trint)
    name="Trint"
    type="zip"
    downloadURL="https://desktopapp.trint.com/latest/darwin/x64/Trint.zip"
    appNewVersion=$(curl -fsL https://desktopapp.trint.com/updates/darwin/x64/RELEASES.json | jq -r .currentRelease)
    expectedTeamID="4SN3PJXHG2"
    ;;
