displaylinkmanager)
    name="DisplayLink Manager"
    type="pkg"
    #packageID="com.displaylink.displaylinkmanagerapp"
    downloadURL=https://www.synaptics.com$(redirect=$(curl -sfL https://www.synaptics.com/products/displaylink-graphics/downloads/macos | grep 'class="download-link">Download' | head -n 1 | sed 's/.*href="//' | sed 's/".*//') && curl -sfL "https://www.synaptics.com$redirect" | grep Accept | head -n 1 | sed 's/.*href="//' | sed 's/".*//')
    appNewVersion=$(curl -sfL https://www.synaptics.com/products/displaylink-graphics/downloads/macos | grep "Release:" | head -n 1 | cut -d ' ' -f2)
    expectedTeamID="73YQY62QM3"
    ;;
