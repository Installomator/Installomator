lightkey)
    name="Lightkey"
    type="pkgInZip"
    blockingProcesses=( "Lightkey" "Lightkey Graphics and Media" "Lightkey Networking" "Lightkey Web Content" )
    downloadURL="https://lightkeyapp.com/en/download"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i ^location | cut -d "/" -f7 | sed 's/Lightkey-//' | tr '-' '.')"
    expectedTeamID="9466VHH352"
    ;;
