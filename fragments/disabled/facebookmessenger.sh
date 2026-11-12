facebookmessenger)
    name="Messenger"
    type="dmg"
    downloadURL="https://www.messenger.com/messenger/desktop/downloadV2/?platform=mac"
    appNewVersion=$(curl -I "${downloadURL}" | awk -F': ' '/^location/ {print $2}' | grep -oE 'Messenger.*\.dmg' | sed 's/Messenger\.//;s/\.dmg//')
    expectedTeamID="V9WTTPBFK9"
    ;;
