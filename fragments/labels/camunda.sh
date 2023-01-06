camunda)
    name="Camunda Modeler"
    type="dmg"
    downloadURL=$(curl -s https://camunda.com/download/modeler/ | grep dmg | sed -n 's/.*href="\([^"]*\)".*/\1/p')
    appNewVersion=$(echo "${downloadURL}" | sed 's/.*release\/camunda-modeler\/\([^\/]*\)\/camunda-modeler-.*/\1/')
    expectedTeamID="3JVGD57JQZ"
    ;;
