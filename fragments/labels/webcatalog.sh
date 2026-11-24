webcatalog)
    name="WebCatalog"
    type="dmg"
    downloadURL=$(curl -fs -o /dev/null -w '%{redirect_url}' "https://trpc.webcatalog.io/api/download?appId=webcatalog&platform=macos")
    appNewVersion=$(basename "$downloadURL" | grep -oE '[0-9]+(\.[0-9]+)+' | head -1)
    expectedTeamID="36UJGA8U65"
    ;;
