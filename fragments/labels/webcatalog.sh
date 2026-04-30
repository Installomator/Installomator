webcatalog)
    name="WebCatalog"
    type="dmg"
    packageID="com.webcatalog.jordan"
    downloadURL="https://desktop.webcatalog.io/api/download?platform=macos&arch=universal"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "^location" | tail -1 | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*).*/\1/g' )
    expectedTeamID="36UJGA8U65"
    ;;
