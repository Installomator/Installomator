scribe)
    name="Scribe Desktop"
    type="dmg"
    scribeData=$(curl -s https://scribehow.com/get-desktop)
    downloadURL=$(echo "$scribeData" | grep -o '"macDownloadUrl":"[^"]*"' | sed 's/"macDownloadUrl":"\(.*\)"/\1/')
    appNewVersion=$(echo "$scribeData" | grep -o '"macVersion":"[^"]*"' | sed 's/"macVersion":"\(.*\)"/\1/')
    expectedTeamID="RWB73CF447"
    ;;
