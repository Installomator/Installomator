unifiendpoint)
    name="UniFi Endpoint"
    type="pkg"
    downloadURL="$(curl -fsL -r 0-0 -o /dev/null -w '%{url_effective}' "https://download.uid.ui.com/?app=DESKTOP-IDENTITY-STANDARD-MACOS")"
    appNewVersion="$(printf '%s' "$downloadURL" | sed -nE 's|.*/[^/]+-macOS-([0-9]+(\.[0-9]+)+)-[^/]+\.pkg$|\1|p')"
    expectedTeamID="4P645293E8"
    blockingProcesses=( NONE )
    ;;
