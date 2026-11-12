fork)
    name="Fork"
    type="dmg"
    downloadURL="$(curl -fs "https://git-fork.com/update/feed.xml" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f 2)"
    appNewVersion=$(printf '%s' "$downloadURL" | sed -nE 's|.*/Fork-([0-9]+(\.[0-9]+)+)\.dmg([?].*)?$|\1|p')
    expectedTeamID="Q6M7LEEA66"
    ;;
