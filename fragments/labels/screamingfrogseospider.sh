screamingfrogseospider)
    name="Screaming Frog SEO Spider"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="$(curl -s https://www.screamingfrog.co.uk/seo-spider/release-history/ | grep -o 'href="https://download.screamingfrog.co.uk/products/seo-spider/ScreamingFrogSEOSpider-[0-9.]*-aarch64.dmg"' | cut -d'"' -f2)"
        appNewVersion="$(echo "$downloadURL" | grep -o '[0-9.]*-aarch64' | cut -d'-' -f1)"
    else
        downloadURL="$(curl -s https://www.screamingfrog.co.uk/seo-spider/release-history/ | grep -o 'href="https://download.screamingfrog.co.uk/products/seo-spider/ScreamingFrogSEOSpider-[0-9.]*-x86_64.dmg"' | cut -d'"' -f2)"
        appNewVersion="$(echo "$downloadURL" | grep -o '[0-9.]*-x86_64' | cut -d'-' -f1)"
    fi
    expectedTeamID="CAHEVC3HZC"
;;