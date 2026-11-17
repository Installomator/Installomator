conductor)
    name="Conductor"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        cnArch="aarch64"
    else
        cnArch="x86_64"
    fi
    downloadURL="https://cdn.crabnebula.app/download/melty/conductor/latest/platform/dmg-${cnArch}"
    appNewVersion=$(curl -fsL "https://cdn.crabnebula.app/update/melty/conductor/darwin-${cnArch}/0.0.0" | grep -o '"version":"[^"]*"' | cut -d'"' -f4)
    expectedTeamID="27XN666UJ7"
    ;;
