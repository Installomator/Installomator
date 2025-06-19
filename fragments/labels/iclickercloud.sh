iclickercloud)
    name="iClicker Cloud"
    type="dmg"
    appNewVersion=$( curl -fs "https://artifactory.reef-education.com/artifactory/app-downloads/" | grep -o 'iclicker-cloud-[0-9].[0-9].[0-9]-mac.dmg' | tail -1 | sed 's/^iclicker-cloud-//g' | sed 's/-mac.dmg$//g' )
    downloadURL="https://artifactory.reef-education.com/artifactory/app-downloads/iclicker-cloud-$appNewVersion-mac.dmg"
    expectedTeamID="5E845CEVPW"
    ;;
