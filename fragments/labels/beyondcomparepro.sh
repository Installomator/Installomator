beyondcomparepro)
    name="Beyond Compare"
    type="zip"
    updateFeed=$(curl -fsL "https://www.scootersoftware.com/checkupdates.php?product=bc5&minor=0&edition=pro&platform=osx&lang=silent")
    rawVersion=$(echo "${updateFeed}" | xpath 'string(/Update/@latestversion)' 2>/dev/null)
    appNewVersion=${rawVersion// build /.}
    downloadURL=$(echo "${updateFeed}" | xpath 'string(/Update/@download)' 2>/dev/null)
    expectedTeamID="BS29TEJF86"
    ;;
