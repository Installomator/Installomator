notion)
    name="Notion"
    type="dmg"
    downloadURL=$(curl -fsIL "https://www.notion.so/desktop/mac/download" | grep -i "^location" | awk '{print $2}' | tr -d '\r\n' | xargs)
    appNewVersion=$(curl -fsIL "$downloadURL" | sed -e 's/.*Notion-\(.*\).dmg.*/\1/' | cut -d '-' -f 1)
    expectedTeamID="LBQJ96FQ8D"
    ;;
