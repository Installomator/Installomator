silentknight)
    name="SilentKnight"
    type="zip"
    folderName=$(curl -fs "https://eclecticlight.co/downloads/" | grep -o 'https://[^"]*silentknight[0-9]*.zip' | sort -V | tail -n 1 | sed 's|.*/\(silentknight[0-9]*\)\.zip|\1|')
    appName="${folderName}/SilentKnight.app"
    downloadURL="https://eclecticlight.co/wp-content/uploads/$(curl -fs "https://eclecticlight.co/downloads/" | grep -o '[0-9]\{4\}/[0-9]\{2\}/silentknight[0-9]*.zip' | sort -V | tail -n 1)"
    appNewVersion="${folderName//[^0-9.]/}"
    expectedTeamID="QWY4LRW926"
    ;;
