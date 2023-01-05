pcoipclient)
    # Note that the sed match removes 'pcoip-client_' and '.dmg' 
    name="PCoIPClient"
    type="dmg"
    downloadURL="https://dl.teradici.com/DeAdBCiUYInHcSTy/pcoip-client/raw/names/pcoip-client-dmg/versions/latest/pcoip-client_latest.dmg"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i ^content-disposition | sed -e 's/.*pcoip-client_//' -e 's/.dmg"//')"
    expectedTeamID="RU4LW7W32C"
    blockingProcesses=( "Teradici PCoIP Client" )
    ;;
