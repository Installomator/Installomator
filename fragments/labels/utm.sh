utm)
    name="UTM"
    type="dmg"
    downloadURL=$(curl -fsIL "https://github.com/utmapp/UTM/releases/latest/download/UTM.dmg" | tr -d '\r' | sed -nE 's|^[Ll]ocation: (https://github\.com/utmapp/UTM/releases/download/v?[0-9]+([.][0-9]+)+/UTM\.dmg)$|\1|p' | head -1)
    appNewVersion=$(echo "$downloadURL" | sed -nE 's|.*/download/v?([0-9]+([.][0-9]+)+)/UTM\.dmg$|\1|p')
    expectedTeamID="WDNLXAD4W8"
    ;;
