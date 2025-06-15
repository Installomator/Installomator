displaylinkmanager)
    name="DisplayLink Manager"
    type="pkgInZip"
    #packageID="com.displaylink.displaylinkmanagerapp"
    downloadURL=https://www.synaptics.com$(redirect=$(curl -sfL https://www.synaptics.com/products/displaylink-graphics/downloads/macos | grep -m 1 'class="download-link">Download' | sed 's/.*href="//' | sed 's/".*//') && curl -sfL "https://www.synaptics.com$redirect" | grep 'class="no-link"' | awk -F 'href="' '{print $2}' | awk -F '"' '{print $1}')
    appNewVersion=$(curl -sfL https://www.synaptics.com/products/displaylink-graphics/downloads/macos | grep -m 1 "Release:" | cut -d ' ' -f2)
    expectedTeamID="73YQY62QM3"
    ;;
