xcreds)
    name="XCreds"
    type="pkg"
    packageID="com.twocanoes.pkg.secureremoteaccess"
    downloadURL="https://twocanoes-software-updates.s3.amazonaws.com/XCreds.pkg"
    appNewVersion=$(curl -fs "https://twocanoes.com/products/mac/xcreds/history/" | grep -A1 "<h3>Change Log</h3>" | sed -n 's/.*<h4>Version \(.*\) Build.*/\1/p')
    expectedTeamID="UXP6YEHSPW"
    blockingProcesses=( NONE )
    ;;
