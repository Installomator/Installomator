opencode)
    name="OpenCode"
    type="dmg"
    downloadURL=$(downloadURLFromGit anomalyco opencode)
    appNewVersion=$(curl -Ls -o /dev/null -w '%{url_effective}' https://github.com/anomalyco/opencode/releases/latest | sed -E 's#.*/tag/v?##')
    expectedTeamID="5NZ4Q7NXJ4"
    ;;
