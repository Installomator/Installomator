skim)
    name="Skim"
    type="dmg"
    downloadURL="$(curl -fsL "https://skim-app.sourceforge.io/skim.xml" | xpath '//rss/channel/item[1]/enclosure/@url' 2>/dev/null | cut -d '"' -f 2)"
    appNewVersion="$(curl -fsL "https://skim-app.sourceforge.io/skim.xml" | xpath '//rss/channel/item[1]/title' 2>/dev/null | sed -n 's/.*Version \([^<]*\)<\/title>.*/\1/p')"
    expectedTeamID="J33JTA7SY9"
    ;;

