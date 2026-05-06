conductor)
    name="Conductor"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://cdn.crabnebula.app/download/melty/conductor/latest/platform/dmg-aarch64"
    else
        downloadURL="https://cdn.crabnebula.app/download/melty/conductor/latest/platform/dmg-x86_64"
    fi
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i "^content-disposition" | sed 's/.*Conductor_\([0-9.]*\)_.*/\1/')
    expectedTeamID="27XN666UJ7"
    ;;
