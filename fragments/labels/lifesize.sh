lifesize)
    name="Lifesize"
    type="dmg"
    downloadURL="https://download.lifesizecloud.com/$(curl -fsL "https://download.lifesizecloud.com/" | xpath '//ListBucketResult/Contents/Key' 2>/dev/null | grep -oE '<Key>(.*\.dmg)</Key>' | sed 's/<Key>\(.*\)<\/Key>/\1/' | tail -1)"
    appNewVersion="$(echo "$downloadURL" | sed 's~https://download\.lifesizecloud\.com/~~;s/Lifesize-//;s/\.dmg//')"
    expectedTeamID="L57M4NT7Y7"
    ;;
