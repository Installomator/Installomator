huddly)
    name="Huddly"
    type="dmg"
    downloadURL="https://app.huddly.com/download/latest/osx"
    appNewVersion="$(curl -fsIL "${downloadURL}" | grep -i '^content-disposition' | sed -E 's/.*-([0-9]+\.[0-9]+\.[0-9]+)-.*/\1/g')"
    expectedTeamID="J659R47HZT"
    ;;
