tophat)
    name="tophat"
    type="zip"
    packageID="com.shopify.tophat"
    downloadURL=$(downloadURLFromGit "shopify" "tophat")
    appNewVersion=$(versionFromGit "shopify" "tophat")
    expectedTeamID="A7XGC83MZE"
    blockingProcesses=( NONE )
    ;;
