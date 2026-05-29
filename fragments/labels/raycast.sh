raycast)
    name="Raycast"
    type="dmg"
    downloadURL="https://releases.raycast.com/download?build=release"
    appNewVersion=$(curl -fsIL -X GET "$downloadURL" | awk 'BEGIN{IGNORECASE=1}/^location:/{gsub("\r",""); print $2}' | tail -n 1 | sed -E 's|.*/Raycast_v?([0-9]+\.[0-9]+\.[0-9]+)_.*|\1|')
    expectedTeamID="SY64MV22J9"
    ;;
