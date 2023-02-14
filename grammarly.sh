grammarly)
    name="Grammarly Desktop"
    type="dmg"
    packageID="com.grammarly.ProjectLlama"
    downloadURL=$(curl -fsL "https://download-mac.grammarly.com/appcast.xml" | xpath '//rss/channel/item[1]/enclosure/@url' 2>/dev/null  | cut -d '"' -f 2)
    expectedTeamID="W8F64X92K3"
    appNewVersion=$(curl -is "https://download-mac.grammarly.com/appcast.xml" | grep sparkle:version | tr ',' '\n' | grep sparkle:version | cut -d '"' -f 4)
    appName="Grammarly Installer.app"
    ;;
