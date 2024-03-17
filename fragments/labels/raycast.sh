raycast)
    name="Raycast"
    type="dmg"
<<<<<<< HEAD
    version=$(curl -s https://releases.raycast.com/releases/latest | grep '"version":' | awk -F'"' '{print $4}')
    downloadURL="https://releases.raycast.com/releases/${version}/download?build=universal"
    appNewVersion=""
=======
    downloadURL="https://www.raycast.com/download"
    appNewVersion="$( curl -fsIL "https://www.raycast.com/download" | grep -i ^location | grep Raycast_ | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/' )"
>>>>>>> pr/1412
    expectedTeamID="SY64MV22J9"
    ;;
