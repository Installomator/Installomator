remotix)
    name="Remotix"
    type="dmg"
    downloadURL="https://remotix.com/downloads/latest-remotix-mac/"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)-.*\.dmg/\1/g' )
    expectedTeamID="K293Y6CVN4"
    ;;
