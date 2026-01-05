displaylinkmanager)
    name="DisplayLink Manager"
    type="pkg"
    appNewVersion=$(curl -sfL https://www.synaptics.com/products/displaylink-graphics/downloads/macos | grep -o 'DisplayLink%20Manager%20Graphics%20Connectivity[0-9.]*-Release' | head -1 | sed 's/DisplayLink%20Manager%20Graphics%20Connectivity//' | sed 's/-Release//')
    productPage=$(curl -sfL https://www.synaptics.com/products/displaylink-graphics/downloads/macos | grep -o 'href="/products/displaylink-manager-graphics-connectivity-[^"]*?filetype=exe"' | head -1 | sed 's/href="//' | sed 's/"$//' | sed 's/?filetype=exe/?filetype=pkg/')
    downloadURL="https://www.synaptics.com$(curl -sfL "https://www.synaptics.com${productPage}" | grep -o '/sites/default/files/exe_files/[^"]*\.pkg' | head -1)"
    expectedTeamID="73YQY62QM3"
    ;;
