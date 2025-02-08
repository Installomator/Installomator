remotedesktopmanagerenterprise)
    name="Remote Desktop Manager"
    type="dmg"
    xml_feed=$(curl -fsL "https://cdn.devolutions.net/download/Mac/RemoteDesktopManager.xml" | sed 's/\\//g' | xmllint --recover -)
    downloadURL=$(echo "${xml_feed}" | xpath 'string(//rss/channel/item[last()]/link)')
    appNewVersion=$(echo "${xml_feed}" | xpath 'string(//rss/channel/item[last()]/enclosure/@sparkle:version)')
    expectedTeamID="N592S9ASDB"
    ;;
