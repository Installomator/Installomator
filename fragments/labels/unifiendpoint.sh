unifiendpoint)
    name="UniFi Endpoint"
    type="pkg"
    # The download link redirects to a versioned pkg; Ubiquiti's gateway answers HEAD with 404, so follow a 1-byte GET
    downloadURL="$(curl -fsL -r 0-0 -o /dev/null -w '%{url_effective}' "https://download.uid.ui.com/?app=DESKTOP-IDENTITY-STANDARD-MACOS")"
    appNewVersion="$(echo "$downloadURL" | sed -E 's/.*-macOS-([0-9.]+)-.*\.pkg$/\1/')"
    expectedTeamID="4P645293E8"
    blockingProcesses=( NONE )
    ;;
