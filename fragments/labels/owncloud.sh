owncloud)
    name="ownCloud"
    type="pkg"
    downloadPage="https://download.owncloud.com/desktop/ownCloud/stable/latest/mac/"
    appNewVersion=$(curl -fsL "$downloadPage" | grep -oE 'ownCloud-[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+-(arm64|x86_64)\.pkg' | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL="${downloadPage}ownCloud-${appNewVersion}-arm64.pkg"
    else
        downloadURL="${downloadPage}ownCloud-${appNewVersion}-x86_64.pkg"
    fi
    expectedTeamID="4AP2STM4H5"
    ;;
