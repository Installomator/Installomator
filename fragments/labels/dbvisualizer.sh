dbvisualizer)
    name="DbVisualizer"
    type="dmg"
    appNewVersion=$(curl -s https://www.dbvis.com/releasenotes/ | grep -o -E 'release--title" id="(.*)">' | sed 's/.*id="v\(.*\)">/\1/' | head -1)
    altVersion=$(echo $appNewVersion | sed 's/\./_/g') # changes 25.1.2 to 25_1_2 for the download URL.
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://www.dbvis.com/product_download/dbvis-${appNewVersion}/media/dbvis_macos-aarch64_${altVersion}.dmg"
    else
        downloadURL="https://www.dbvis.com/product_download/dbvis-${appNewVersion}/media/dbvis_macos-x64_${altVersion}.dmg"
    fi
    expectedTeamID="U9TP5KYV49"
    ;;
