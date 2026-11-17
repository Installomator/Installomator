silentknight3)
    name="SilentKnight 3"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fsL "https://eclecticlight.co/downloads/" | grep -Eo 'https://eclecticlight\.co/wp-content/uploads/[0-9]{4}/[0-9]{2}/sk[0-9]+\.zip' | sort -V | tail -n 1)
        folderName="${downloadURL##*/}"
        folderName="${folderName%.zip}"
        appName="${folderName}/SilentKnight3.app"
        appNewVersion=$(echo "$downloadURL" | sed -E 's|.*/sk([0-9])([0-9]{2})\.zip|\1.\2|')
    else
        printlog "SilentKnight 3 requires an Apple silicon Mac." ERROR
        cleanupAndExit 95 "SilentKnight 3 requires Apple silicon" ERROR
    fi
    expectedTeamID="QWY4LRW926"
    blockingProcesses=( "SilentKnight3" )
    ;;
