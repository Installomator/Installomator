iclickercloud)
    name="iClicker Cloud"
    type="dmg"
    appNewVersion=$( curl -fs "https://www.iclicker.com/downloads/iclicker-cloud/" | grep -o 'iclicker-cloud-[0-9].[0-9].[0-9]-mac.dmg' | tail -1 | sed 's/^iclicker-cloud-//g' | sed 's/-mac.dmg$//g' )
    downloadURL="https://downloads.iclicker.com/app-downloads/iclicker-cloud-$appNewVersion-mac.dmg"
    expectedTeamID="5E845CEVPW"
    ;;
