remotedesktopmanagerfree)
    name="Remote Desktop Manager Free"
    type="dmg"
    downloadURL=$(curl -fs https://remotedesktopmanager.com/home/thankyou/rdmmacfreebin | grep -oe "http.*\.dmg" | head -1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*\.Mac\.([0-9.]*)\.dmg/\1/g')
    expectedTeamID="N592S9ASDB"
    ;;
