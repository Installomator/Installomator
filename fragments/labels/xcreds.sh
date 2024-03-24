xcreds)
    name="XCreds"
    # Downloading from twocanoes homepage
    type="pkg"
    #packageID="com.twocanoes.pkg.secureremoteaccess"
    downloadURL="https://twocanoes-software-updates.s3.amazonaws.com/XCreds.pkg"
    appNewVersion=$(curl -fs "https://twocanoes.com/products/mac/xcreds/history/" | grep -A1 "<h3>Change Log</h3>" | sed -n 's/.*<h4>Version \(.*\) Build.*/\1/p')
    # GitHub download
    # type="pkg"
    # downloadURL="$(downloadURLFromGit twocanoes xcreds)"
    # appNewVersion="$(versionFromGit twocanoes xcreds)" # GitHub tag contain “_” and not “.” so our function fails to get the right version
    # appNewVersion=$(echo "$downloadURL" | sed -E 's/.*XCreds_.*-([0-9.]*)\.pkg/\1/')
    expectedTeamID="UXP6YEHSPW"
    ;;
