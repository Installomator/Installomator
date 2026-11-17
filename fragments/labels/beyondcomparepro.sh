beyondcomparepro)
    name="Beyond Compare"
    type="zip"
    updateFeed=$(curl -fsL -H 'User-Agent: Beyond%20Compare/5' "https://www.scootersoftware.com/checkupdates.php?product=bc5&maint=1&minor=1&build=10000&edition=pro&platform=osx&lang=silent")
    rawVersion=$(echo "${updateFeed}" | xpath 'string(/Update/@latestversion)' 2>/dev/null)
    appNewVersion=${rawVersion// build /.}
    downloadURL=$(echo "${updateFeed}" | xpath 'string(/Update/@download)' 2>/dev/null)
    expectedTeamID="BS29TEJF86"
    ;;
