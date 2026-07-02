dbvisualizer)
    name="DbVisualizer"
    type="dmg"
    dbvisVersion=$(curl -fsL "https://www.dbvis.com/download/" | grep -oE 'Latest version [0-9]+(\.[0-9]+)+' | head -n 1 | awk '{print $3}')
    appNewVersion="$dbvisVersion"
    if [[ "$appNewVersion" =~ ^[0-9]+\.[0-9]+$ ]]; then
        appNewVersion="${appNewVersion}.0"
    fi
    downloadVersion="${dbvisVersion//./_}"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://www.dbvis.com/product_download/dbvis-${dbvisVersion}/media/dbvis_macos-aarch64_${downloadVersion}.dmg"
    else
        downloadURL="https://www.dbvis.com/product_download/dbvis-${dbvisVersion}/media/dbvis_macos-x64_${downloadVersion}.dmg"
    fi
    expectedTeamID="U9TP5KYV49"
    ;;
