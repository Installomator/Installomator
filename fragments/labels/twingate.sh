twingate)
    name="Twingate"
    type="pkg"
    downloadURL="https://api.twingate.com/download/darwin?installer=pkg"
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i ^location | cut -d "/" -f6 | cut -d "." -f1 -f2)
    expectedTeamID="6GX8KVTR9H"
    ;;
