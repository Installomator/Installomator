druvainsync)
    name="Druva inSync"
    type="pkgInDmg"
    appNewVersion=$(getJSONValue "$(curl -fsL curl -fs https://downloads.druva.com/insync/js/data.json)" "[1].supportedVersions[0]")
    downloadURL=$(getJSONValue "$(curl -fsL curl -fs https://downloads.druva.com/insync/js/data.json)" "[1].installerDetails[0].downloadURL")
    expectedTeamID="JN6HK3RMAP"
    ;;
