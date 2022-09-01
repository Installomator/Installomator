xcreds)
    name="XCreds"
    type="pkgInZip"
    #packageID="com.twocanoes.pkg.secureremoteaccess"
    downloadURL=$(curl -fs "https://twocanoes.com/products/mac/xcreds/" | grep -ioE "https://.*\.zip" | head -1)
    appNewVersion=$(curl -fs "https://twocanoes.com/products/mac/xcreds/" | grep -io "Current Version:.*" | sed -E 's/.*XCreds *([0-9.]*)<.*/\1/g')
    expectedTeamID="UXP6YEHSPW"
    ;;
