catoclient)
    name="CatoClient"
    type="pkg"
    downloadURL="https://clientdownload.catonetworks.com/public/clients/CatoClient.pkg"
    appNewVersion=$(curl -fsSL -I -o /dev/null -w '%{url_effective}' "$downloadURL" | sed -nE 's|.*/([0-9]+\.[0-9]+\.[0-9]+)(\.[0-9]+)?/.*|\1|p')
    expectedTeamID="CKGSB8CH43"
    ;;
