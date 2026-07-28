appautopatch)
	name="App Auto-Patch"
	type="pkg"
	downloadURL="$(downloadURLFromGit App-Auto-Patch App-Auto-Patch)"
	appNewVersion="$(versionFromGit App-Auto-Patch App-Auto-Patch)"
	expectedTeamID="4XSYV3BTMX"
	appCustomVersion(){ /usr/bin/grep -m 1 '^scriptVersion=' "/Library/Management/AppAutoPatch/App-Auto-Patch-via-Dialog.zsh" 2>/dev/null | sed -E 's/^scriptVersion="?([0-9.]+)"?.*/\1/' }
	;;
