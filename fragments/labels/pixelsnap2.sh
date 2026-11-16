pixelsnap2)
    name="PixelSnap 2"
    type="dmg"
    downloadURL=$(curl -fsL https://updates.getpixelsnap.com/v2/appcast.xml | grep -oE 'url="https://updates\.getpixelsnap\.com/v2/PixelSnap-2-[0-9.]+\.dmg"' | head -1 | cut -d'"' -f2)
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*PixelSnap-2-([0-9.]+)\.dmg/\1/')
    expectedTeamID="AFJU4P8ZV4"
    ;;
