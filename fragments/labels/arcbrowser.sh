arcbrowser)
    name="Arc"
    type="dmg"
    downloadURL="https://releases.arc.net/release/Arc-latest.dmg"
    appNewVersion=$(curl -fsIL "$downloadURL" | awk 'BEGIN{IGNORECASE=1}/^location:/{gsub("\r",""); print $2}' | tail -n 1 | sed -E 's|.*/Arc-([0-9]+(\.[0-9]+)+)-[0-9]+\.dmg|\1|')
    expectedTeamID="S6N382Y83G"
    ;;
