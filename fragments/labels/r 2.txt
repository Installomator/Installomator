r)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="R"
    type="pkg"
    downloadURL=$( curl -fsL https://formulae.brew.sh/api/cask/r.json | sed -n 's/^.*"url":"\([^"]*\)".*$/\1/p' )
    appNewVersion=$(curl -fsL https://formulae.brew.sh/api/cask/r.json | sed -n 's/^.*"version":"\([^"]*\)".*$/\1/p')
    expectedTeamID="VZLD955F6P"
    ;;
