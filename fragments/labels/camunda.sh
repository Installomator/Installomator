camunda)
    name="Camunda Modeler"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fs https://camunda.com/download/modeler/ |  sed -n 's/.*href="\([^"]*\)".*/\1/p' | grep arm64.dmg)
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fs https://camunda.com/download/modeler/ |  sed -n 's/.*href="\([^"]*\)".*/\1/p' | grep x64.dmg)
    fi
    appNewVersion=$(echo "${downloadURL}" | sed 's/.*release\/camunda-modeler\/\([^\/]*\)\/camunda-modeler-.*/\1/')
    expectedTeamID="3JVGD57JQZ"
    ;;
