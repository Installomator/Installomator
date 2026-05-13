bitwigstudio)
    name="Bitwig Studio"
    type="dmg"
    appNewVersion="$(curl -fs "https://www.bitwig.com/download/" | grep 'changelog' | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')"
    downloadURL="https://www.bitwig.com/dl/Bitwig%20Studio/${appNewVersion}/installer_mac/"
    expectedTeamID="2B6K987585"
    ;;
