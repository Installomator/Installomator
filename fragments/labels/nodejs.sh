nodejs)
    name="nodejs"
    type="pkg"
    packageID="org.nodejs.node.pkg"
    appNewVersion=$(getJSONValue "$(curl -fsL https://nodejs.org/dist/index.json)" "[0].version")
    downloadURL="https://nodejs.org/dist/${appNewVersion}/node-${appNewVersion}.pkg"
    expectedTeamID="HX7739G8FX"
    blockingProcesses=( NONE )
    ;;
