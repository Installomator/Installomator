macvector)
    name="MacVector"
    type="dmg"
    appNewVersion="$(curl -fsL "https://macvector.com/support/installers-and-updaters/" | grep -oE 'MacVector [0-9]+\.[0-9]+\.[0-9]+' | head -1 | awk '{print $2}')"
    downloadURL="https://macvector.net/MacVector${appNewVersion}(64).dmg"
    folderName="MacVector"
    appName="${folderName}/MacVector.app"
    versionKey="CFBundleShortVersionString"
    expectedTeamID="BK85R8X44N"
    ;;
