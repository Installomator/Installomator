jumpdesktopmac)
    name="Jump Desktop"
    type="zip"
    downloadURL="https://mirror.jumpdesktop.com/downloads/JumpDesktopMac.zip"
    appNewVersion="$(curl -fs https://mirror.jumpdesktop.com/downloads/jdm/jdmac-web-appcast.xml | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | head -1 | cut -d '"' -f 2)"
    expectedTeamID="2HCKV38EEC"
    ;;
