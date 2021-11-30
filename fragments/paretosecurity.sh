paretosecurity)
    name="Pareto Security"
    type="dmg"
    downloadURL=$(curl -fs "https://api.github.com/repos/ParetoSecurity/pareto-mac/releases/latest" \
      | awk -F '"' '/browser_download_url/ && /dmg/ { print $4 }')
    expectedTeamID="PM784W7B8X"
    ;;
