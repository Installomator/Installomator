morisawadesktopmanager)
    name="Morisawa Desktop Manager"
    type="pkgInDmg"
    packageID="jp.co.morisawa.MorisawaDesktopManager.Installer"
    morisawadesktopmanagerVersions=$(curl -fsL https://morisawafonts.com/resources/dm/mf_updates.mac.json)
    downloadURL=$(getJSONValue "${morisawadesktopmanagerVersions}" "latest_url")
    appNewVersion=$(getJSONValue "${morisawadesktopmanagerVersions}" "latest_version")
    expectedTeamID="662PVPVA3N"
    ;;
