arcbrowser\
|arc)
name="Arc"
type="dmg"
downloadURL="https://releases.arc.net/release/Arc-latest.dmg"
appNewVersion="$(curl -fsIL https://releases.arc.net/release/Arc-latest.dmg | grep -i ^location | tail -n 1 |sed -E 's/.*-([0-9]+\.[0-9]+\.[0-9]).*/\1/')"
expectedTeamID="S6N382Y83G"
    ;;
