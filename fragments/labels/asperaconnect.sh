asperaconnect|\
ibmasperaconnect)
    name="IBM Aspera Connect"
    type="pkg"
    appInfo=$(curl -fsL "https://d3gcli72yxqn2z.cloudfront.net/downloads/connect/latest/versions.js"|sed 's/^window.connectVersions = //')
    appNewVersion=$(getJSONValue "$appInfo" "entries[1].version"|awk -F. '{print $1"."$2"."$3}')
    downloadURL="https://d3gcli72yxqn2z.cloudfront.net/downloads/connect/latest/$(getJSONValue "$appInfo" "entries[1].links[1].href")"
    expectedTeamID="PETKK2G752"
    ;;
