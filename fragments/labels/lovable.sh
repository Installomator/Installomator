lovable)
	name="Lovable"
	type="dmg"
	appName="Lovable.app"
	downloadURL="https://downloads.lovable.dev/desktop/latest/mac"
	appNewVersion="$(curl -fsIL "$downloadURL" | grep -i '^content-disposition' | sed -E 's/.*Lovable-([0-9]+\.[0-9]+\.[0-9]+)-mac-arm64\.dmg.*/\1/')"
	expectedTeamID="SWJU3R2URD"
	;;