lunadisplay)
    name="Luna Display"
    type="dmg"
    downloadURL=$(curl -fsLI "https://downloads.astropad.com/luna/mac/latest" | grep -i '^location:' | tail -n 1 | cut -d ' ' -f 2 | tr -d '\r' | sed 's|^/|https://downloads.astropad.com/|')
    appNewVersion=$(echo $downloadURL | sed -E 's/.*LunaDisplay-([0-9.]+).dmg/\1/')
    expectedTeamID="8356ZZ8Y5K"
    ;;
