notion)
    name="Notion"
    type="dmg"
    downloadURL="https://www.notion.so/desktop/mac/download"
    appNewVersion=$(curl -fsL "https://desktop-release.notion-static.com/latest-mac.yml" | awk -F': ' '/^version:/{print $2; exit}')
    expectedTeamID="LBQJ96FQ8D"
    ;;
