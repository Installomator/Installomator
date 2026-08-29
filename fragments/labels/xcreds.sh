xcreds)
    name="XCreds"
    type="pkg"
    packageID="com.twocanoes.pkg.secureremoteaccess"
    downloadURL="https://twocanoes-software-updates.s3.amazonaws.com/XCreds.pkg"
    appNewVersion=$(getJSONValue "$(curl -fsL "https://data.twocanoes.com/api/version_info")" '["com.twocanoes.xcreds"].version')
    expectedTeamID="UXP6YEHSPW"
    blockingProcesses=( NONE )
    ;;
