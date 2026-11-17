grammarly)
    name="Grammarly Desktop"
    type="dmg"
    grammarlyFeed="$(curl -fsL "https://download-mac.grammarly.com/appcast.xml")"
    downloadURL="$(echo "${grammarlyFeed}" | xpath 'string(//rss/channel/item[1]/enclosure/@url)' 2>/dev/null)"
    appNewVersion="$(echo "${grammarlyFeed}" | xpath 'string(//rss/channel/item[1]/enclosure/@sparkle:version)' 2>/dev/null)"
    versionKey="CFBundleVersion"
    expectedTeamID="W8F64X92K3"
    installerTool="Grammarly Installer.app"
    CLIInstaller="Grammarly Installer.app/Contents/MacOS/Grammarly Desktop"
    ;;
