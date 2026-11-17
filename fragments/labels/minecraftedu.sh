minecraftedu)
    name="minecraft-edu"
    type="dmg"
    downloadURL=$(curl -fsIL "https://aka.ms/meeclientmacos" | tr -d '\r' | grep -i "^location:" | tail -1 | awk '{print $2}')
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*[_-]([0-9]+(\.[0-9]+)+)\.dmg$/\1/')
    versionKey="CFBundleVersion"
    expectedTeamID="UBF8T346G9"
    ;;
