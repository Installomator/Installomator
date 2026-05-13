dracoon)
    name="Dracoon"
    type="zip"

    #update feed
    feedURL="https://d1ch1ptxef4ena.cloudfront.net/branding/be347f75-2ea9-418f-8894-3c2228483e01/macos/release/changelog.rss"

    #get download url from sparkle feed
    downloadURL="$(curl -fs $feedURL | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f 2)"

    #get version from sparkle feed
    appNewVersion="$(curl -fs $feedURL | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f 2)"

    expectedTeamID="G69SCX94XU"
    blockingProcesses=("DRACOON Finder Integration")
    ;;
