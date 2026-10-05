cricutdesignspace)
    name="Cricut Design Space"
    type="dmg"
    cricutVersionURL=$(getJSONValue $(curl -fsL "https://apis.cricut.com/desktopdownload/UpdateJson?operatingSystem=osxnative&shard=a") "result")
    cricutVersionJSON=$(curl -fs "$cricutVersionURL")
    appNewVersion=$(getJSONValue "$cricutVersionJSON" "rolloutVersion")
    downloadURL=$(getJSONValue $(curl  -fsL "https://apis.cricut.com/desktopdownload/InstallerFile?shard=a&operatingSystem=osxnative&fileName=CricutDesignSpace-Install-v${appNewVersion}.dmg") "result")
    expectedTeamID="25627ZFVT7"
    ;;

