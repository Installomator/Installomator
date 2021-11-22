inkscape)
    # credit: Søren Theilgaard (@theilgaard)
    name="Inkscape"
    type="dmg"
    downloadURL="https://inkscape.org$(curl -fs https://inkscape.org$(curl -fsJL https://inkscape.org/release/  | grep "/release/" | grep en | head -n 1 | cut -d '"' -f 6)mac-os-x/dmg/dl/ | grep "click here" | cut -d '"' -f 2)"
    appCustomVersion() { /Applications/Inkscape.app/Contents/MacOS/inkscape --version | cut -d " " -f2 }
    appNewVersion=$(curl -fsJL https://inkscape.org/release/  | grep "<title>" | grep -o -e "[0-9.]*")
    expectedTeamID="SW3D6BB6A6"
    ;;
