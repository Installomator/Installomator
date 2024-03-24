remotedesktopmanagerfree)
    name="Remote Desktop Manager"
    type="dmg"
    downloadURL=$(curl -fsL https://devolutions.net/remote-desktop-manager/home/thankyou/rdmmacbin/ | grep -oe "http.*\.dmg" | head -1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*\.Mac\.([0-9.]*)\.dmg/\1/g')
    expectedTeamID="N592S9ASDB"
    ;;
