screamingfrogseospider)
    name="Screaming Frog SEO Spider"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
        platform="x86_64"
    elif [[ $(arch) == arm64 ]]; then
        platform="aarch64"
    fi
    appNewVersion=$(curl -fs "https://download.screamingfrog.co.uk/products/seo-spider/getlatestversion.php")
    downloadURL="https://download.screamingfrog.co.uk/products/seo-spider/ScreamingFrogSEOSpider-${appNewVersion}-${platform}.dmg"
    expectedTeamID="CAHEVC3HZC"
    ;;
