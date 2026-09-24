displaylinkmanager)
    name="DisplayLink Manager"
    type="pkg"
    pageURL="https://www.synaptics.com/products/displaylink-graphics/downloads/macos"
    pageHTML=$(/usr/bin/curl -fsSL "$pageURL")
    releaseNotesURL=$(print -r -- "$pageHTML" | /usr/bin/grep -Eio "href=[\"'][^\"']*Release(%20| )Notes\.txt[\"']" | /usr/bin/head -n 1 | /usr/bin/sed -E "s/^href=[\"']//; s/[\"']\$//; s/&amp;/\&/g; s/ /%20/g")
    releaseNotesURL="https://www.synaptics.com${releaseNotesURL}"
    appNewVersion=$(/usr/bin/curl -fsSL "$releaseNotesURL" | /usr/bin/head -n 15 | /usr/bin/tr -d '\r' | /usr/bin/awk -F':' '/^[[:space:]]*Version:/ { gsub(/[[:space:]]/, "", $2); print $2; exit }')
    productPage=$(echo "$pageHTML" | grep -o 'href="/products/displaylink-manager-graphics-connectivity-[^"]*?filetype=exe"' | head -1 | sed 's/href="//' | sed 's/"$//' | sed 's/?filetype=exe/?filetype=pkg/')
    downloadURL="https://www.synaptics.com$(curl -sfL "https://www.synaptics.com${productPage}" | grep -o '/sites/default/files/exe_files/[^"]*\.pkg' | head -1)"
    expectedTeamID="73YQY62QM3"
    ;;
