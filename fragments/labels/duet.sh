duet)
    name="Duet"
    type="dmg"
    downloadURL="https://updates.duetdisplay.com/AppleSilicon"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i ^location | cut -d "/" -f6 | sed 's/duet-dd-//' | sed 's/.dmg//' | sed 's/-/./g')"
    expectedTeamID="J6L96W8A86"
    blockingProcesses=( "duet" "duet Networking" )
    ;;
