enteauth)
    name="Ente Auth"
    type="dmg"
    appNewVersion="$(getJSONValue "$(curl -fs https://ente.com/release-info/auth-independent.json)" "latestVersion.name" | sed 's/^v//')"
    downloadURL="https://github.com/ente-io/ente/releases/download/auth-v${appNewVersion}/ente-auth-v${appNewVersion}.dmg"
    expectedTeamID="6Z68YJY9Q2"
    ;;
