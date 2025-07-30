enteauth)
    name="Ente Auth"
    type="dmg"
    appNewVersion="$(curl -sfL https://ente.io/release-info/auth-independent.json | grep '"name": ' | awk '{print $2}' | awk -F\" '{print $2}' | sed 's/^v//')"
    downloadURL="https://github.com/ente-io/ente/releases/download/auth-v${appNewVersion}/ente-auth-v${appNewVersion}.dmg"
# | sed 's/\ /%20/g')
    expectedTeamID="6Z68YJY9Q2"
    ;;
