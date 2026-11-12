tesseraremote)
    name="Tessera Remote"
    type="dmg"
    tesseraReleasePage=$(curl -fsL "https://www.bromptontech.com/support/downloads/" | xmllint --html --xpath 'string(//div[@id="downloads"]//a[contains(@href, "http") and contains(@href, "tessera") and not(contains(@href, "beta"))]/@href)' - 2>/dev/null)
    downloadURL=$(curl -fsL "$tesseraReleasePage" | xmllint --html --xpath 'string(//div[@id="releaseDetailsBlock"]//a[contains(@href, "Tessera_Remote") and substring(@href, string-length(@href)-3, 4) = ".dmg"]/@href)' - 2>/dev/null)
    appNewVersion=$(sed -E 's#.*Tessera_Remote_v([0-9]+\.[0-9]+\.[0-9]+)_installer\.dmg#\1#' <<< "$downloadURL")
    appName="Tessera Remote $appNewVersion.app"
    expectedTeamID="7J5M6EPN5V"
    ;;
