epicgameslauncher)
	name="Epic Games Launcher"
	type="dmg"
	downloadURL="https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncher.dmg"
	appNewVersion=$( curl -s "https://trello.com/b/GXLc34hk.json" | jq -r '.cards[] | select(.name | test("Epic Games Launcher [0-9]+\\.[0-9]+(\\.[0-9]+)?")) | .name' | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | sort -V | tail -n 1 )
	versionKey="CFBundleShortVersionString"
	expectedTeamID="96DBZ92D3Y"
	;;
