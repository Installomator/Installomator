raycast)
    name="Raycast"
    type="dmg"
    downloadURL="https://www.raycast.com/download"
    appNewVersion="$( curl -fsIL "https://www.raycast.com/download" | grep -i ^location | grep Raycast_ | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/' )"
    expectedTeamID="SY64MV22J9"
    ;;
