vpntracker365)
	#credit BigMacAdmin @ Second Son Consulting
	name="VPN Tracker 365"
	type="zip"
	downloadURL="https://www.vpntracker.com/goto/HPdownload/VPNT365Latest"
	appNewVersion="$(curl -fsIL ${downloadURL}  | grep -i ^location | grep -i ".zip" | sed 's/.*VPN Tracker 365 - //g' | sed 's/.zip//g')"
	expectedTeamID="MJMRT6WJ8S"
	;;
