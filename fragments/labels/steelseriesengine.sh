steelseriesengine)
    name="SteelSeries GG"
    type="pkg"
    downloadURL="https://steelseries.com/engine/latest/darwin"
    appNewVersion="$(curl -fsIL "$downloadURL" | grep -i "^location" | sed -E 's/.*SteelSeriesGG([0-9.]*)\.pkg/\1/')"
    expectedTeamID="6WGL6CHFH2"
    ;;
