notioncalendar)
    name="Notion Calendar"
    type="dmg"
    downloadURL=$(curl -fsIL "https://www.notion.so/calendar/desktop/mac-apple-silicon/download" | grep -i "^location" | awk '{print $2}' | tr -d '\r\n')
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "^etag" | awk '{print $2}' | tr -d '"')
    expectedTeamID="R8DNJ3GNHX"
    ;;
