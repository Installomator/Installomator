raycast)
    name="Raycast"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://www.raycast.com/download"
    else
        printlog "Raycast is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "Raycast requires Apple Silicon" ERROR
    fi
    appNewVersion="$(curl -fsSIL -o /dev/null -w '%{url_effective}' "$downloadURL" | sed -nE 's|.*/Raycast_([0-9]+(\.[0-9]+)+)_[^/]+\.dmg$|\1|p')"
    expectedTeamID="SY64MV22J9"
    ;;
