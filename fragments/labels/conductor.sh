conductor)
    name="Conductor"
    type="dmg"
    downloadURL="https://cdn.crabnebula.app/download/melty/conductor/latest/platform/dmg-aarch64"
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i "^content-disposition" | sed 's/.*Conductor_\([0-9.]*\)_.*/\1/')
    expectedTeamID="27XN666UJ7"
    ;;
