adium)
    name="Adium"
    type="dmg"
    appNewVersion="$(curl -sL "https://adium.im" | grep -i 'class="downloadlink"' | sed -r 's/.*href="([^"]+).*/\1/g' | sed -n 's:.*Adium_\(.*\).dmg.*:\1:p')"
    downloadURL="https://adiumx.cachefly.net/Adium_${appNewVersion}.dmg"
    expectedTeamID="VQ6ZEL8UD3"
    ;;
