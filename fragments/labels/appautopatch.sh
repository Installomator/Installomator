appautopatch)
	name="App Auto-Patch"
	type="pkg"
	downloadURL="$(downloadURLFromGit App-Auto-Patch App-Auto-Patch)"
	appNewVersion="$(versionFromGit App-Auto-Patch App-Auto-Patch)"
	expectedTeamID="4XSYV3BTMX"
	appCustomVersion(){ /usr/local/bin/appautopatch --vers 2>/dev/null }
	;;
