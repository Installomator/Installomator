githubdesktop)
    name="GitHub Desktop"
    type="zip"
    downloadURL="https://central.github.com/deployments/desktop/desktop/latest/darwin"
    appNewVersion=$(curl -fsL https://central.github.com/deployments/desktop/desktop/changelog.json | awk -F '{' '/"version"/ { print $2 }' | sed -E 's/.*,\"version\":\"([0-9.]*)\".*/\1/g')
    expectedTeamID="VEKTX9H2N7"
    ;;
