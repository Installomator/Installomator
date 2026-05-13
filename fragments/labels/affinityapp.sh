affinityapp)
    name="Affinity"
    type="dmg"
    appName="Affinity.app"
    downloadURL="https://downloads.affinity.studio/Affinity.dmg"
    appNewVersion=$(curl -fsL "https://affinity-update.s3.amazonaws.com/mac2/retail/studiopro.xml" | xpath '//rss/channel/item/sparkle:deltas/enclosure/@sparkle:shortVersionString' 2>/dev/null | cut -d '"' -f 2)
    expectedTeamID="5HD2ARTBFS"
    ;;
