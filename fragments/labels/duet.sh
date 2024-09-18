duet)
    name="Duet"
    type="zip"
    downloadURL="https://updates.duetdisplay.com/AppleSilicon"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i ^location | cut -d "/" -f6 | sed 's/duet-//' | sed 's/.zip//' | sed 's/-/./g')"
    expectedTeamID="J6L96W8A86"
    blockingProcesses=( "duet" "duet Networking" )
    ;;
