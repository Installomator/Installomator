jamovi)
    name="jamovi"
    type="dmg"
    downloadSERVER="http://www.jamovi.org"
    downloadPATH="$(curl -s "$downloadSERVER/download.html" | grep macos | grep -m1 data-href | cut -d '"' -f 2)"
    downloadURL="${downloadSERVER}${downloadPATH}"
    appNewVersion="$(echo $downloadPATH | cut -d '-' -f 2)"
    expectedTeamID="9NCBP559AB"
    ;;
