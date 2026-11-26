fontexplorer)
    name="FontExplorer X Pro"
    type="dmg"
    packageID="com.linotype.FontExplorerX"
    downloadURL="http://www.fontexplorerx.com/download/free-trial/Mac/"
    appNewVersion=$( curl -fsL http://fex.linotype.com/update/client/mac/pro/version.plist | grep string | tail -n 1 | sed 's/[^0-9.]//g' )
    expectedTeamID="2V7G2B7WG4"
    ;;

