pop)
    name="Pop"
    type="dmg"
    appNewVersion=$(curl -fsL "https://scrn-prod.firebaseio.com/appUpdate/darwin/latest.json" | tr -d '"')
    downloadURL="https://download.pop.com/desktop-app/darwin/${appNewVersion}/Pop.dmg"
    expectedTeamID="2MUHEYXYSF"
    ;;
