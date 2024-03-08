raycast)
    name="Raycast"
    type="dmg"
    version=$(curl -s https://releases.raycast.com/releases/latest | grep '"version":' | awk -F'"' '{print $4}')
    downloadURL="https://releases.raycast.com/releases/${version}/download?build=universal"
    appNewVersion=""
    expectedTeamID="SY64MV22J9"
    ;;
