vocevistavideopro)
    name="VoceVista Video Pro"
    type="dmg"
    voceVistaDownloadPage=$(curl --compressed -fsL "https://www.vocevista.com/en/download-mac/")
    downloadURL=$(grep -Eo "https://download\.sygyt\.com/[^\"[:space:]]+/VoceVistaVideoPro_macOS_[0-9.]+\.dmg" <<< "$voceVistaDownloadPage" | head -1)
    appNewVersion=$(echo "$downloadURL" | sed -nE 's#.*VoceVistaVideoPro_macOS_([0-9]+\.[0-9]+\.[0-9]+)(\.[0-9]+)?\.dmg#\1#p')
    expectedTeamID="MZ25LZ65AM"
    ;;
