8x8)
    name="8x8 Work"
    type="dmg"
    pageContent=$(curl -fsL "https://help.8x8.com/docs/download-8x8-work-for-desktop" | sed 's/&quot;/"/g')
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(echo "$pageContent" | grep -o 'https://work-desktop-assets\.8x8\.com/prod-publish/ga/work-arm64-dmg-v[0-9][0-9.-]*\.dmg' | sort -Vr | head -n 1)
    else
        downloadURL=$(echo "$pageContent" | grep -o 'https://work-desktop-assets\.8x8\.com/prod-publish/ga/work-dmg-v[0-9][0-9.-]*\.dmg' | sort -Vr | head -n 1)
    fi
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*-v([0-9]+\.[0-9]+\.[0-9]+)-.*/\1/')
    expectedTeamID="FC967L3QRG"
    ;;
