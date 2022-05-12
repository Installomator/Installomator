clue)
    #For personal use and students
    name="Clue"
    type="dmg"
    downloadURL=$(curl -fsL https://clue.no/en/download | grep "For personal use and students:" | sed 's/.*href="//' | sed 's/".*//')
    appNewVersion="$(echo "${downloadURL}" | sed -E 's/.*Clue*([0-9.]*)\..*/\1/g')"
    versionKey="CFBundleVersion"
    expectedTeamID="3NX6B9TB2F"
    ;;
