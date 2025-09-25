remotedesktopmanagerfree)
    name="Remote Desktop Manager"
    type="dmg"
    downloadURL=$(curl -fsL https://devolutions.net/remote-desktop-manager/download/thank-you/\?platform\=RDMMacbin\&edition\=free\&os\=macos | grep "const productInfo" | grep -oe "{.*}" | jq -r '."RDMMacbin.Url"')
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*\.Mac\.([0-9.]*)\.dmg/\1/g')
    expectedTeamID="N592S9ASDB"
    ;;
