druvainsyncgov)
    name="Druva inSync"
    type="pkgInDmg"
    druvaFeed=$(curl -fsL "https://downloads.druva.com/insync/js/data.json")
    appNewVersion=$(echo "$druvaFeed" | jq -r '.[] | select(.title=="macOS" and (.cloudopsNotes | test("GOVcloud"; "i"))) | .supportedVersions[0]')
    downloadURL=$(echo "$druvaFeed" | jq -r '.[] | select(.title=="macOS" and (.cloudopsNotes | test("GOVcloud"; "i"))) | .installerDetails[0].downloadURL')
    expectedTeamID="JN6HK3RMAP"
    ;;
