xattred)
    name="xattred"
    type="zip"
    folderName=$(curl -fs "https://eclecticlight.co/downloads/" | grep -o 'xattred[0-9.]*.zip' | sort -V | tail -n 1 | sed 's/\.zip$//')
    appName="${folderName}/xattred.app"
    downloadURL="https://eclecticlight.co/wp-content/uploads/2025/12/${folderName}.zip"
    appNewVersion="${folderName//[^0-9.]/}"
    expectedTeamID="QWY4LRW926"
    ;;
