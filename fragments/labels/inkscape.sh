inkscape)
    # credit: Søren Theilgaard (@theilgaard)
    name="Inkscape"
    type="dmg"
    appCustomVersion() { /Applications/Inkscape.app/Contents/MacOS/inkscape --version | cut -d " " -f2 }
    appNewVersion=$(curl -fsJL https://inkscape.org/release/  | grep "<title>" | grep -o -e "[0-9.]*")
    downloadURL=https://media.inkscape.org/dl/resources/file/Inkscape-"$appNewVersion"_"$(arch)".dmg
    expectedTeamID="SW3D6BB6A6"
    ;;
