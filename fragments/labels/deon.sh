deon-cloud|\
deon-onprem|\
deon)
    name="Deon"
    type="dmg"

    feedURL="https://download.deon.de/index.php?action=1&product=Mac&channel=wpf"
    if [[ $(arch) != "arm64" ]]; then
        printlog "Architecture: i386"
        downloadURL=$(curl -fs $feedURL | jq -r '.uris.[] | select(test("Intel"))')
    else
        printlog "Architecture: arm64 (not i386)"
        downloadURL=$(curl -fs $feedURL | jq -r '.uris.[] | select(test("Silicon"))')
    fi

    appNewVersion=$(curl -fs $feedURL | jq -r '.version')
    expectedTeamID="EW9H238RWQ"
    ;;
