remotedesktopmanager|\
remotedesktopmanagerfree|\
remotedesktopmanagerenterprise)
    name="Remote Desktop Manager"
    type="dmg"
    productInfo=$(curl -fsL "https://devolutions.net/productinfo.htm" | tr -d '\r')
    downloadURL=$(printf '%s\n' "$productInfo" | awk -F= '/^RDMMacbin\.Url=/{print $2; exit}')
    appNewVersion=$(printf '%s\n' "$productInfo" | awk -F= '/^RDMMacbin\.Version=/{print $2; exit}')
    expectedTeamID="N592S9ASDB"
    blockingProcesses=( $name )
    ;;
