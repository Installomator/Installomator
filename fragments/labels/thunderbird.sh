thunderbird)
    name="Thunderbird"
    type="dmg"
    versionKey="CFBundleShortVersionString"
    downloadURL=$(curl -fsIL "https://download.mozilla.org/?product=thunderbird-latest&os=osx&lang=en-US" | grep -i "^location:" | tail -1 | awk '{ print $2 }' | tr -d '\r')
    appNewVersion=$(echo "$downloadURL" | sed -E 's|.*/releases/([^/]+)/mac/.*|\1|')
    expectedTeamID="43AQ936H96"
    ;;
