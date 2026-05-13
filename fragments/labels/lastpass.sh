lastpass)
    name="LastPass"
    type="dmg"
    downloadURL="https://download.cloud.lastpass.com/mac/LastPass.dmg"
    appNewVersion="$(curl -fs "https://download.cloud.lastpass.com/mac/AppCast.xml" | xpath 'string(//rss/channel/item/title)' 2>/dev/null)"
    expectedTeamID="N24REP3BMN"
    ;;
