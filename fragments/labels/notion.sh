notion)
    name="Notion"
    type="dmg"
    downloadURL=$(curl -fsIL "https://www.notion.so/desktop/mac/download" | grep -i "^location" | awk '{print $2}' | tr -d '\r\n' | xargs)
    appNewVersion=$(echo "$downloadURL" | sed -e 's/.*Notion-\(.*\).dmg.*/\1/' | cut -d '-' -f 1)
    if [ "$(curl -s -o /dev/null -w '%{http_code}' -I "$downloadURL")" != "200" ]; then
        altURL="${downloadURL/-universal.dmg/.dmg}"
        if [ "$altURL" != "$downloadURL" ] && [ "$(curl -s -o /dev/null -w '%{http_code}' -I "$altURL")" = "200" ]; then
            downloadURL="$altURL"
        fi
    fi
    expectedTeamID="LBQJ96FQ8D"
    ;;
