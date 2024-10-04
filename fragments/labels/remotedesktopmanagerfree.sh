remotedesktopmanagerfree)
    name="Remote Desktop Manager"
    type="dmg"
    downloadURL=$(curl -fsL https://cdn.devolutions.net/download/Mac/Devolutions.RemoteDesktopManager.Mac.2024.3.4.3.dmg | grep -oe "http.*\.dmg" | head -1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*\.Mac\.([0-9.]*)\.dmg/\1/g')
    expectedTeamID="N592S9ASDB"
    ;;
