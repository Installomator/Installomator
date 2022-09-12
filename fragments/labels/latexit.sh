latexit)
    name="LaTeXiT"
    type="dmg"
    downloadURL="$(curl -fs "https://pierre.chachatelier.fr/latexit/downloads/latexit-sparkle-en.rss" | xpath '(//rss/channel/item/enclosure/@url)[last()]' 2>/dev/null | cut -d '"' -f 2)"
    appNewVersion="$(curl -fs "https://pierre.chachatelier.fr/latexit/downloads/latexit-sparkle-en.rss" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[last()]' 2>/dev/null | cut -d '"' -f 2)"
    expectedTeamID="7SFX84GNR7"
    ;;
