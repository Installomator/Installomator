vocevistapro|\
vocevistavideopro)
    name="VoceVista Pro"
    type="dmg"
    appNewVersion="$(curl -Is https://www.vocevista.com/downloads/vocevista-pro-mac/ | grep -iE 'download|dmg|zip|pkg' | sed -E 's#.*_([0-9.]+)\.dmg#\1#' | tr -d '\r\n')"
    appShortVersion="${appNewVersion%.*}"
    downloadURL="https://download.sygyt.com/${appShortVersion}/VoceVistaPro_macOS_${appNewVersion}.dmg"
    expectedTeamID="MZ25LZ65AM"
    ;;
