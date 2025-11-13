vocevistavideopro)
    name="VoceVista Video Pro"
    type="dmg"
    appNewVersion=$(curl --compressed -fsL "https://www.vocevista.com/en/download-mac/" | grep -o ".\{0,0\}Version.\{0,20\}" | sed 's/\Version //'| cut -d "<" -f1)
    trimVersion=$(curl --compressed -fsL "https://www.vocevista.com/en/download-mac/" | grep -o ".\{0,0\}Version.\{0,20\}" | sed 's/\Version //'| cut -d "." -f 1-3)
    downloadURL="https://download.sygyt.com/$trimVersion/VoceVistaVideoPro_macOS_$appNewVersion.dmg"
    expectedTeamID="MZ25LZ65AM"
    ;;
