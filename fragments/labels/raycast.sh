raycast)
    name="Raycast"
    type="dmg"
    appNewVersion=$(curl -fsIL "https://releases.raycast.com/download?build=arm" | awk 'BEGIN{IGNORECASE=1}/^location:/{print $2}' | sed -E 's|.*/releases/([0-9]+\.[0-9]+\.[0-9]+)/.*|\1|')
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL="https://releases.raycast.com/releases/${appNewVersion}/download?build=arm"
    else
        downloadURL="https://releases.raycast.com/releases/${appNewVersion}/download?build=x86_64"
    fi
    expectedTeamID="SY64MV22J9"
    ;;
