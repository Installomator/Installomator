camunda)
    name="Camunda Modeler"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fsL https://docs.camunda.io/downloads/ | grep -oE 'https://downloads\.camunda\.cloud/release/camunda-modeler/[^"]*mac-arm64\.dmg' | head -1)
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fsL https://docs.camunda.io/downloads/ | grep -oE 'https://downloads\.camunda\.cloud/release/camunda-modeler/[^"]*mac-x64\.dmg' | head -1)
    fi
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*camunda-modeler\/([^\/]*)\/camunda-modeler-.*/\1/')
    expectedTeamID="3JVGD57JQZ"
    ;;
