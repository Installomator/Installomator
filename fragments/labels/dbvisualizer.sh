dbvisualizer)
    name="DbVisualizer"
    type="dmg"
    appNewVersion=$(curl -fsL "https://www.dbvis.com/download/" | sed -n 's/.*Latest version \([0-9.]*\).*/\1/p' | head -n1)
    versionUnderscore="${appNewVersion//./_}"
    downloadURL="https://www.dbvis.com/product_download/dbvis-${appNewVersion}/media/dbvis_macos-aarch64_${versionUnderscore}.dmg"
    expectedTeamID="U9TP5KYV49"
    blockingProcesses=( "DbVisualizer" )
    ;;
