inkscape)
    # credit: Søren Theilgaard (@theilgaard)
    name="Inkscape"
    type="dmg"
    appCustomVersion() { /Applications/Inkscape.app/Contents/MacOS/inkscape --version | cut -d " " -f2 }
    appNewVersion=$(curl -fsJL https://inkscape.org/release/  | grep "<title>" | grep -o -e "[0-9.]*")
    if [[ $(arch) == arm64 ]]; then
        downloadURL=https://media.inkscape.org/dl/resources/file/Inkscape-"$appNewVersion"_arm64.dmg
    elif [[ $(arch) == i386 ]]; then
        downloadURL=https://media.inkscape.org/dl/resources/file/Inkscape-"$appNewVersion"_x86_64.dmg
    fi
    expectedTeamID="SW3D6BB6A6"
    ;;
