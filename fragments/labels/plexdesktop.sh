plexdesktop)
    name="Plex"
    type="zip"
    downloadURL=$(curl -fs https://plex.tv/api/downloads/6.json | sed -n 's/.*"url":"\([^"]*-universal.zip\)".*/\1/p')
    appNewVersion=$(curl -fs https://plex.tv/api/downloads/6.json | sed -n 's/.*"version":"\([^"]*\)".*/\1/p')
    versionKey="CFBundleShortVersionString"
    expectedTeamID="K4QJ56KR4A"
    ;;
