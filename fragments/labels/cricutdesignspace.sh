cricutdesignspace)
    name="Cricut Design Space"
    type="dmg"
    cricutUpdateJSON=$(curl -fsL 'https://apis.cricut.com/desktopdownload/UpdateJson?operatingSystem=osxnative&shard=a')
    cricutVersionURL=$(getJSONValue "$cricutUpdateJSON" "result")
    cricutVersionJSON=$(curl -fsL "$cricutVersionURL")
    appNewVersion=$(getJSONValue "$cricutVersionJSON" "rolloutVersion")
    cricutInstallerJSON=$(curl -fsL "https://apis.cricut.com/desktopdownload/InstallerFile?shard=a&operatingSystem=osxnative&fileName=CricutDesignSpace-Install-v${appNewVersion}.dmg")
    downloadURL=$(getJSONValue "$cricutInstallerJSON" "result")
    expectedTeamID="25627ZFVT7"
    ;;
