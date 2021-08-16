proxyman)
	name="Proxyman"
	type="dmg"
	downloadURL="https://proxyman.io/release/osx/Proxyman_latest.dmg"
	expectedTeamID="3X57WP8E8V"
	appNewVersion=$(curl -s -L https://github.com/ProxymanApp/Proxyman | grep -o 'releases/tag/.*\>' | awk -F '/' '{print $3}')
	;;
