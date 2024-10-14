screamingfrogseospider)
    name="Screaming Frog SEO Spider"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
        platform="Mac - (intel)"
    elif [[ $(arch) == arm64 ]]; then
        platform="Mac - (apple silicon)"
    fi
    downloadURL=$(curl -fs "https://www.screamingfrog.co.uk/" | grep "$platform" | grep "ScreamingFrogSEOSpider" | sed -r 's/.*href="([^"]+).*/\1/g' )
    appNewVersion=$( awk -F'-' '{print $3}' <<< "$downloadURL" )
    expectedTeamID="CAHEVC3HZC"
    ;;
