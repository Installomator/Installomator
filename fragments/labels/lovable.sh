lovable)
	name="Lovable"
	type="dmg"
	if [[ $(arch) == "arm64" ]]; then
		downloadURL="https://downloads.lovable.dev/desktop/latest/mac"
	else
		printlog "Lovable is only compatible with Apple Silicon (arm64) Macs." ERROR
		cleanupAndExit 95 "Lovable requires Apple Silicon" ERROR
	fi
	appNewVersion="$(curl -fsIL "$downloadURL" | grep -i '^content-disposition' | sed -E 's/.*Lovable-([0-9]+\.[0-9]+\.[0-9]+)-mac-arm64\.dmg.*/\1/')"
	expectedTeamID="SWJU3R2URD"
	;;
