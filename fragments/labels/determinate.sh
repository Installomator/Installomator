determinate)
    name="Determinate"
    type="pkg"
    packageID="systems.determinate.Determinate"
    downloadURL="https://install.determinate.systems/determinate-pkg/stable/Universal"
    appNewVersion=$(curl -sfI "${downloadURL}"  | awk -F'/' '/location: /{print $4}')
    expectedTeamID="X3JQ4VPJZ6"
    ;;
