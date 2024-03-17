airtamepkg)
    name="Airtame"
    type="pkg"
    packageID="com.airtame.airtame-application"
    appNewVersion="$(curl -fs https://airtame.com/download/ | grep -i platform=mac | head -1 | grep -o -i -E "https.*" | cut -d '"' -f1 | xargs curl -fsIL | grep -i ^location | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')"
    downloadURL="https://airtame-app.b-cdn.net/app/latest/mac/Airtame-${appNewVersion}.pkg"
    expectedTeamID="4TPSP88HN2"
    ;;
