vpntracker365)
    name="VPN Tracker 365"
    type="zip"
    downloadURL=$(curl -fsSIL -o /dev/null -w '%{url_effective}' "https://www.vpntracker.com/goto/HPdownload/VPNT365Latest")
    appNewVersion=${${downloadURL%.zip}##*%20}
    expectedTeamID="MJMRT6WJ8S"
    ;;
