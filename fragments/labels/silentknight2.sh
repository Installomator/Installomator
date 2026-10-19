silentknight|silentknight2)
    name="SilentKnight"
    type="zip"
    downloadURL=$(curl -fsL "https://eclecticlight.co/downloads/" | grep -Eo 'https://eclecticlight\.co/wp-content/uploads/[0-9]{4}/[0-9]{2}/silentknight[0-9]+\.zip' | sort -V | tail -n 1)
    folderName="${downloadURL##*/}"
    folderName="${folderName%.zip}"
    appName="${folderName}/SilentKnight.app"
    appNewVersion=$(echo "$downloadURL" | sed -E 's|.*/silentknight([0-9])([0-9]{2})\.zip|\1.\2|')
    expectedTeamID="QWY4LRW926"
    ;;
