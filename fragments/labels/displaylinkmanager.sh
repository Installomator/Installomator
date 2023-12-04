displaylinkmanager)
    name="DisplayLink Manager"
    type="pkg"
    #packageID="com.displaylink.displaylinkmanagerapp"
    downloadURL=https://www.synaptics.com$(redirect=$(curl -sfL https://www.synaptics.com/products/displaylink-graphics/downloads/macos | grep 'class="download-link">Download' | sed -n '2p' | sed 's/.*href="//' | sed 's/".*//') && curl -sfL "https://www.synaptics.com$redirect" | grep 'class="no-link"' | awk -F 'href="' '{print $2}' | awk -F '"' '{print $1}')
    appNewVersion=$(curl -sfL https://www.synaptics.com/products/displaylink-graphics/downloads/macos | grep "Release:" | sed -n '2p' | cut -d ' ' -f2)
    expectedTeamID="73YQY62QM3"
    ;;
