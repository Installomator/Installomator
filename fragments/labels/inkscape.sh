inkscape)
    name="Inkscape"
    type="dmg"
    appCustomVersion() { /Applications/Inkscape.app/Contents/MacOS/inkscape --version | cut -d " " -f2 }
    appNewVersion=$(curl -fsL https://inkscape.org/release/  | grep "<title>" | grep -o -e "[0-9.]*")
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://media.inkscape.org/dl/resources/file/$(curl -fsL https://inkscape.org/release/inkscape-{$appNewVersion}/mac-os-x/dmg-arm64/dl/ | grep -o -m1 "Inkscape-.*.dmg")"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://media.inkscape.org/dl/resources/file/$(curl -fsL https://inkscape.org/release/inkscape-{$appNewVersion}/mac-os-x/dmg/dl/ | grep -o -m1 "Inkscape-.*.dmg")"
    fi
    expectedTeamID="SW3D6BB6A6"
    ;;
