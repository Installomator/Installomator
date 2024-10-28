catoclient)
    name="CatoClient"
    type="pkg"
    downloadURL="https://clientdownload.catonetworks.com/public/clients/CatoClient.pkg"
    appNewVersion=$(curl -Ls -o /dev/null -w %{url_effective} "${downloadURL}" | sed -E 's/.*\/([0-9.]*)\/.*/\1/g' | awk -F '.' '{print $1 "." $2 "." $3}')
    expectedTeamID="CKGSB8CH43"
    blockingProcesses=( "CatoClient" "CatoClientExtension" )
    ;;
