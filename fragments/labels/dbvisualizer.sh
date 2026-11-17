dbvisualizer)
    name="DbVisualizer"
    type="dmg"
    downloadPage=$(curl -fsL "https://www.dbvis.com/download/")
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://www.dbvis.com$(echo "$downloadPage" | grep -Eo '/product_download/dbvis-[0-9.]+/media/dbvis_macos-aarch64_[0-9_]+\.dmg' | head -1)"
    else
        downloadURL="https://www.dbvis.com$(echo "$downloadPage" | grep -Eo '/product_download/dbvis-[0-9.]+/media/dbvis_macos-x64_[0-9_]+\.dmg' | head -1)"
    fi
    appNewVersion=$(echo "$downloadURL" | sed -nE 's#.*/dbvis-([0-9]+(\.[0-9]+)+)/media/dbvis_macos-(aarch64|x64)_[0-9_]+\.dmg#\1#p')
    expectedTeamID="U9TP5KYV49"
    ;;
