loopcloud)
    name="Loopcloud"
    type="pkgInZip"
    downloadXML="$(curl -fs 'https://www.loopmasters.com/cloud/autoupdate/mac/release/appcast.xml')"
    downloadURL="$(echo "${downloadXML}" | xpath 'string(//rss/channel/item/enclosure/@url)' 2>/dev/null | sed 's/ /%20/g' )"
    appNewVersion="$(echo "${downloadXML}" | xpath 'string(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null)"
    expectedTeamID="6J526HR25E"
    ;;
