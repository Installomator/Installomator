dbvisualizer)
    name="DbVisualizer"
    type="dmg"
    dbvisVersion=$(curl -fsL "https://www.dbvis.com/download/" | grep -oE 'Latest version [0-9]+(\.[0-9]+)+' | head -n 1 | awk '{print $3}')
    appNewVersion=$(echo "$dbvisVersion" | awk -F. '{for (i = NF+1; i <= 3; i++) $i = 0; print $1"."$2"."$3}')
    downloadVersion="${dbvisVersion//./_}"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://www.dbvis.com/product_download/dbvis-${dbvisVersion}/media/dbvis_macos-aarch64_${downloadVersion}.dmg"
    else
        downloadURL="https://www.dbvis.com/product_download/dbvis-${dbvisVersion}/media/dbvis_macos-x64_${downloadVersion}.dmg"
    fi
    expectedTeamID="U9TP5KYV49"
    ;;
