cricutdesignspace)
    name="Cricut Design Space"
    type="dmg"
    appNewVersion=$(getJSONValue "$(curl -fsL https://s3-us-west-2.amazonaws.com/staticcontent.cricut.com/a/software/osx-native/latest.json)" "rolloutVersion")
    downloadURL=$(getJSONValue $(curl  -fsL "https://apis.cricut.com/desktopdownload/InstallerFile?shard=a&operatingSystem=osxnative&fileName=CricutDesignSpace-Install-v${appNewVersion}.dmg") "result")
    expectedTeamID="25627ZFVT7"
    ;;
