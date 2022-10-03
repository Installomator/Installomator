xcreds)
    name="XCreds"
    # Downloading from twocanoes homepage
    #type="pkgInDmg"
    #packageID="com.twocanoes.pkg.secureremoteaccess"
    #downloadURL=$(curl -fs "https://twocanoes.com/products/mac/xcreds/" | grep -ioE "https://.*\.zip" | head -1)
    #appNewVersion=$(curl -fs "https://twocanoes.com/products/mac/xcreds/" | grep -io "Current Version:.*" | sed -E 's/.*XCreds *([0-9.]*)<.*/\1/g')
    # GitHub download
    type="pkg"
    downloadURL="$(downloadURLFromGit twocanoes xcreds)"
    #appNewVersion="$(versionFromGit twocanoes xcreds)" # GitHub tag contain “_” and not “.” so our function fails to get the right version
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*XCreds_.*-([0-9.]*)\.pkg/\1/')
    expectedTeamID="UXP6YEHSPW"
    ;;
