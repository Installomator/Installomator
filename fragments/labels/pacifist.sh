pacifist)
    name="Pacifist"
    type="dmg"
    downloadURL="https://charlessoft.com/cgi-bin/pacifist_download.cgi?type=dmg"
    appNewVersion="$(curl -fsL "https://www.charlessoft.com/cgi-bin/pacifist_sparkle.cgi" | xpath 'string(//rss/channel/item[last()]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)"
    expectedTeamID="HRLUCP7QP4"
    ;;
