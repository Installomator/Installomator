keyshot|\
keyshot2024)
    name="KeyShot"
    type="pkg"
    expectedTeamID="W7B24M74T3"
    downloadURL="https://www.keyshot.com/download/370762/"
    appNewVersion="$( curl -v "$downloadURL" 2>&1 | grep location | cut -d '_' -f 4 | cut -d '.' -f 1-2 )"
    ;;
