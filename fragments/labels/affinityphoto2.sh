affinityphoto2)
    name="Affinity Photo 2"
    type="dmg"
    downloadURL=$(curl -fs "https://store.serif.com/en-gb/update/macos/photo/2/" | grep -i -o -E "https.*\.dmg.*\"" | sort | tail -n1 | sed 's/.$//' | sed 's/&amp;/\&/g')
    appNewVersion=$(curl -fs "https://store.serif.com/en-gb/update/macos/photo/2/" | grep -i -o -E "https.*\.dmg" | sort | tail -n1 | tr "-" "\n" | grep dmg | sed -E 's/([0-9.]*)\.dmg/\1/g')
    expectedTeamID="6LVTQB9699"
    ;;
