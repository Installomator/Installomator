vpntracker365)
	#credit BigMacAdmin @ Second Son Consulting
	name="VPN Tracker 365"
	type="zip"
	downloadURL="https://www.vpntracker.com/goto/HPdownload/VPNT365Latest"
	appNewVersion="$(curl -fsIL ${downloadURL}  | grep -i ^location | grep -i ".zip" | tail -1 | sed 's/.*VPN Tracker 365 - //g'| awk '{print $1}')"
	expectedTeamID="MJMRT6WJ8S"
	blockingProcesses=( "VPN Tracker 365" )
	;;
