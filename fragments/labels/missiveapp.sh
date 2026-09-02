missive)
    name="Missive"
    type="dmg"
    downloadURL="https://mail.missiveapp.com/download/mac"
    appNewVersion=$(curl -fsLI -o /dev/null -w '%{url_effective}' "$downloadURL" | sed -E 's#.*/Missive-([0-9]+(\.[0-9]+)+)\.dmg#\1#')
    expectedTeamID="PXGQRRXCJN"
    ;;
