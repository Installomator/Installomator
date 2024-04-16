scribus)
    name="Scribus"
    type="dmg"
    appNewVersion="$(curl -fs https://www.scribus.net/downloads/ | grep "current stable version" | sed -E 's/.*Scribus is ([0-9.]*)\..*/\1/')"
    # Handling differens on Apple Silicon and Intel arch
    if [[ $(arch) = "arm64" ]]; then
        printlog "Architecture: arm64"
        downloadURL="https://sourceforge.net/projects/scribus/files/scribus/${appNewVersion}/scribus-${appNewVersion}-arm64.dmg/download"
    else
        printlog "Architecture: i386 (not arm64)"
        downloadURL="https://sourceforge.net/projects/scribus/files/scribus/${appNewVersion}/scribus-${appNewVersion}.dmg/download"
    fi
    expectedTeamID="627FV4LMG7"
    ;;
