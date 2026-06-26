notioncalendar)
    name="Notion Calendar"
    type="dmg"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL="https://www.notion.so/calendar/desktop/mac-apple-silicon/download"
    else
        downloadURL="https://www.notion.so/calendar/desktop/mac-intel/download"
    fi
    appNewVersion="$(curl -fsIL "$downloadURL" | grep -i "^location" | grep -i "dmg" | awk '{print $2}' | sed -e 's/.*Notion%20Calendar-\(.*\).dmg.*/\1/' | cut -d '-' -f 1)"
    expectedTeamID="LBQJ96FQ8D"
    ;;
