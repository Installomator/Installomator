notion)
    # credit: Søren Theilgaard (@theilgaard)
    name="Notion"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://www.notion.so/desktop/apple-silicon/download"
        appNewVersion=$( curl -fsIL "https://www.notion.so/desktop/apple-silicon/download" | grep -i "^location" | awk '{print $2}' | sed -e 's/.*Notion\-\(.*\)\-arm64.dmg.*/\1/' )
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://www.notion.so/desktop/mac/download"
        appNewVersion=$( curl -fsIL "https://www.notion.so/desktop/mac/download" | grep -i "^location" | awk '{print $2}' | sed -e 's/.*Notion\-\(.*\).dmg.*/\1/' )
    fi
    expectedTeamID="LBQJ96FQ8D"
    ;;
