genesyscloud)
    name="Genesys Cloud"
    type="dmg"
    downloadURL=$(curl -s https://apps.mypurecloud.com/directory-mac/ | grep -oE 'https://[^"]+\.dmg' | head -n 1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*genesys-cloud-mac-([0-9.]+)\.dmg/\1/')
    expectedTeamID="9U57N843V9"
    ;;
