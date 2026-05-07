airtame)
    name="Airtame"
    type="dmg"
    downloadURL="https://downloads-website.airtame.com/get.php?platform=mac"
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i "location" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    expectedTeamID="4TPSP88HN2"
    ;;
