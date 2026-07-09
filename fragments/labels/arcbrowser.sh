arcbrowser)
name="Arc"
type="dmg"
downloadURL="https://releases.arc.net/release/Arc-latest.dmg"
appNewVersion="$(curl -fsIL https://releases.arc.net/release/Arc-latest.dmg | grep -iE '^location:.*-[0-9]+\.[0-9]+\.[0-9]+-[0-9]+\.dmg' | sed -E 's/.*-([0-9]+\.[0-9]+\.[0-9]+)-[0-9]+.*/\1/')"
expectedTeamID="S6N382Y83G"
    ;;
