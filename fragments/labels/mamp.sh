mamp)
    name="MAMP"
    type="pkg"
    downloadURL="$(curl -fsL 'https://www.mamp.info/en/downloads/' | grep -o 'https://downloads.mamp.info/MAMP-PRO/macOS/MAMP-PRO/MAMP-MAMP-PRO-[^"]*.pkg' | head -1)"
    appNewVersion="$(echo "${downloadURL}" | grep -o 'MAMP-MAMP-PRO-[0-9]*\.[0-9]*' | sed 's/MAMP-MAMP-PRO-//')"
    expectedTeamID="5KCB5KHK77"
    ;;
