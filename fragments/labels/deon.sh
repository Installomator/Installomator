deon)
    name="Deon"
    type="dmg"
    deonJSON=$(curl -fsL "https://download.deon.de/index.php?action=1&product=Mac&channel=wpf")
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(getJSONValue "$deonJSON" "uris[1]")
    else
        downloadURL=$(getJSONValue "$deonJSON" "uris[0]")
    fi
    appNewVersion=$(echo "$downloadURL" | sed -nE 's#.*filename=DEON_(Intel|Silicon)_([0-9]+(\.[0-9]+)+)\.dmg.*#\2#p')
    expectedTeamID="EW9H238RWQ"
    ;;
