inkscape)
    # credit: Søren Theilgaard (@theilgaard)
    name="Inkscape"
    type="dmg"
    downloadURL="https://inkscape.org$(curl -fs https://inkscape.org$(curl -fsJL https://inkscape.org/release/  | grep "/release/" | grep en | head -n 1 | cut -d '"' -f 6)mac-os-x/1010-1015/dl/ | grep "click here" | cut -d '"' -f 2)"
    #appNewVersion=$(curl -fsJL https://inkscape.org/release/  | grep "<h2>Inkscape" | cut -d '>' -f 3 | cut -d '<' -f 1 | sed 's/[^0-9.]*//g') # Can't figure out where exact new version is found. Currently returns 1.0, but version is "1.0.0 (4035a4f)"
    expectedTeamID="SW3D6BB6A6"
    ;;
