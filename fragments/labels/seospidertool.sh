seospidertool)
    name="Screaming Frog SEO Spider"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
      downloadURL="https://download.screamingfrog.co.uk/products/seo-spider/ScreamingFrogSEOSpider-aarch64.dmg"
    elif [[ $(arch) == i386 ]]; then
      downloadURL="https://download.screamingfrog.co.uk/products/seo-spider/ScreamingFrogSEOSpider-x86_64.dmg"
    fi
    expectedTeamID="CAHEVC3HZC"
    ;;