dedoose)
    name="Dedoose"
    type="dmg"
    appNewVersion=$(curl -I https://downloads.dedoose.com/dedoose-app-releases/Dedoose-Mac.dmg | grep -o "Dedoose-Mac-v[0-9.].*[0-9.].*[0-9.].dmg" | sed -e 's/Dedoose-Mac-v//g' -e 's/.dmg//g')
    downloadURL="https://downloads.dedoose.com/dedoose-app-releases/Dedoose-Mac.dmg"
    expectedTeamID="9U74Q6K62X"
    ;;
