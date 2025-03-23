epsoneppt)
    name="Epson EPPT"
    appName="Epson Projector Professional Tool/EPPT.app"
    type="pkgInDmg"
    blockingProcesses=( "EPPT" )
    userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/536.28.10 (KHTML, like Gecko) Version/6.0.3 Safari/536.28.10"
    pageURL="https://epson.com/Support/Other-Products/Epson-Software/Epson-Projector-Professional-Tool-Software/s/SPT_Epson-PJ-Pro-Tool?review-filter=macOS+10.15.x"
    downloadURL=$(curl -A $userAgent -fs $pageURL | xmllint --html -xpath "string((//a[contains(@href, '.dmg')])[1]/@href)" - 2> /dev/null)
    appNewVersion=$( echo "${downloadURL}" | grep -oE '_([0-9.]+)' | sed 's/.$//' | cut -d'_' -f2)
    expectedTeamID="TXAEAV5RN4"
    ;;
