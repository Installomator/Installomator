teamviewer)
    name="TeamViewer"
    type="pkg"
    teamViewerFeed=$(curl -fsL "https://download.teamviewer.com/download/update/macupdates.xml?lang=en&version=15.00.0&os=macos&osversion=27.0&type=1&channel=1")
    downloadURL=$(echo "$teamViewerFeed" | xpath 'string((//rss/channel/item/enclosure[@teamviewer:module="full"][@teamviewer:kind="pkg"])[1]/@url)' 2>/dev/null)
    appNewVersion=$(echo "$teamViewerFeed" | xpath 'string((//rss/channel/item/enclosure[@teamviewer:module="full"][@teamviewer:kind="pkg"])[1]/@sparkle:version)' 2>/dev/null)
    expectedTeamID="H7UGFBUGV6"
    ;;
