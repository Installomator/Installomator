notion)
    name="Notion"
    type="dmg"
    downloadURL="https://www.notion.so/desktop/mac/download"
    appNewVersion=$(curl -fsIL "https://www.notion.so/desktop/mac/download" | grep -i "^location" | awk '{print $2}' | sed -e 's/.*Notion-\(.*\).dmg.*/\1/' | cut -d '-' -f 1)
    expectedTeamID="LBQJ96FQ8D"
    ;;
