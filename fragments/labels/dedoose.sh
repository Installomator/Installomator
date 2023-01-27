dedoose)
    name="Dedoose"
    type="dmg"
    downloadURL=$(echo -n "https:" && curl -fs "https://www.dedoose.com/resources/articledetail/dedoose-desktop-app" | grep -o '//.*dmg')
    appNewVersion=$(echo "$downloadURL" | awk -F'[-.]' '{print $2}') # Cannot be compared to anything
    expectedTeamID="9U74Q6K62X"
    ;;