dedoose)
    name="Dedoose"
    type="dmg"
    downloadURL=$(curl https://www.dedoose.com/resources/articledetail/dedoose-desktop-app | grep "Dedoose-.*[0-9.].*[0-9.].*[0-9.]dmg" | cut -d'/' -f3- | cut -f1 -d'"' | cut -c2-)
    appNewVersion=$(curl https://www.dedoose.com/resources/articledetail/dedoose-desktop-app | grep -o "Dedoose-.*[0-9.].*[0-9.].*[0-9.]" | cut -d'>' -f2- | tail -1)
    expectedTeamID="9U74Q6K62X"
    ;;

