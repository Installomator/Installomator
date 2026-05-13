dedoose)
    name="Dedoose"
    type="dmg"
    downloadURL="https://downloads.dedoose.com/dedoose-app-releases/Dedoose-Mac.dmg"
    appNewVersion=$(curl -fsI https://downloads.dedoose.com/dedoose-app-releases/Dedoose-Mac.dmg | grep -i "^content-disposition:" | grep -o "v[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}" | sed 's/^v//')
    expectedTeamID="9U74Q6K62X"
    ;;
