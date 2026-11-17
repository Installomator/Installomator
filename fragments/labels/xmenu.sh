xmenu)
    name="XMenu"
    type="zip"
    devonPlist=$(curl -fsL "https://www.devontechnologies.com/Updates.plist?product=XMenu&version=1.0.0")
    appNewVersion=$(echo "$devonPlist" | plutil -extract "XMenu" raw -o - -)
    downloadURL="https://download.devontechnologies.com/download/freeware/xmenu/${appNewVersion}/XMenu.app.zip"
    expectedTeamID="679S2QUWR8"
    ;;
