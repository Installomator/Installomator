tesseraremote)
    name="TeserraRemote"
    type="dmg"
    pageURL="https://www.bromptontech.com/support/downloads/"
    downloadURL="$(curl -fs $pageURL | xmllint --html --xpath 'string(//div[@id="downloads"]//a[contains(@href, "http")]/@href)' - 2> /dev/null \
    | head -1 \
    | xargs -I {} curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) ..." -fs {} \
    | xmllint --html --xpath 'string(//div[@id="releaseDetailsBlock"]//a[substring(@href, string-length(@href)-3, 4) = ".dmg"]/@href)' - 2> /dev/null)"
    appNewVersion=$( echo "${downloadURL}" | grep -oE '[0-9]+.[0-9]+.[0-9]+')
    expectedTeamID="7J5M6EPN5V"
    appName="Tessera Remote $appNewVersion.app"
    ;;
