qualified)
    name="Qualified"
    type="dmg"
    downloadURL="https://app.qualified.com/download/mac"
    appNewVersion=$(curl -fsIL -o /dev/null -w '%{url_effective}' "$downloadURL" | sed -E 's|.*/Qualified-([0-9]+(\.[0-9]+)+)-universal\.dmg([?].*)?$|\1|')
    expectedTeamID="X4K33UUA44"
    ;;
