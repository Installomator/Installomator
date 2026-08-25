xcreds)
    name="XCreds"
    type="pkg"
    packageID="com.twocanoes.pkg.secureremoteaccess"
    downloadURL=$(curl -fsL "https://twocanoes.com/products/mac/xcreds/history/" | awk '/<h3>Change Log<\/h3>/{found=1; next} found && /https:\/\/twocanoes-software-updates\.s3\.amazonaws\.com\/XCreds_Build-[0-9]+_Version-[0-9.]+\.pkg/{print; exit}' | sed -E 's|.*href="([^"]+)".*|\1|')
    appNewVersion=$(echo "$downloadURL" | sed -E 's|.*_Version-([0-9.]+)\.pkg|\1|')
    expectedTeamID="UXP6YEHSPW"
    blockingProcesses=( NONE )
    ;;
