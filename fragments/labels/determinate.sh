determinate)
    name="Determinate"
    type="pkg"
    packageID="systems.determinate.Determinate"
    # Note: https://install.determinate.systems/determinate-pkg/stable/Universal may return different URLs if a deploy is in progress.
    # Fetching https://install.determinate.systems/determinate-pkg/stable/Universal and capturing the redirect target ensures the
    # version printed is the version that will actually be installed.
    downloadUrl=$(curl -w "%{url_effective}\n" -I -L -s -S https://install.determinate.systems/determinate-pkg/stable/Universal -o /dev/null)
    appNewVersion=$(echo "$downloadUrl" | cut -d/ -f4)
    expectedTeamID="X3JQ4VPJZ6"
    ;;
