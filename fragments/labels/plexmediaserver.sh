plexmediaserver)
	name="Plex Media Server"
	type="zip"
	downloadURL=$(curl -fs https://plex.tv/api/downloads/5.json | sed -E 's/.*(https:\/\/downloads.plex.tv\/plex-media-server-new\/([0-9\.]+)-[a-z0-9]+\/macos\/PlexMediaServer-[0-9\.]+-[a-z0-9]+-universal\.zip).*/\1/')
	appNewVersion=$(echo $downloadURL | sed -E 's/.*(https:\/\/downloads.plex.tv\/plex-media-server-new\/([0-9\.]+)-[a-z0-9]+\/macos\/PlexMediaServer-[0-9\.]+-[a-z0-9]+-universal\.zip).*/\2/' | cut -d '.' -f 1-3 )
	versionKey="CFBundleShortVersionString"
	expectedTeamID="K4QJ56KR4A"
;;
