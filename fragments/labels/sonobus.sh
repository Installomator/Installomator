sonobus)
    name="Sonobus"
    type="pkgInDmg"
    html_page_source="$(curl -fs 'https://www.sonobus.net')"
    downloadFile="$(echo "${html_page_source}" | xmllint --html --xpath "string(//a[contains(@href, 'mac.dmg')]/@href)" - 2> /dev/null)"
    downloadURL="https://www.sonobus.net/$downloadFile"
    appNewVersion="$(echo "${downloadFile}" | sed 's/releases\/sonobus-//' | sed 's/\-mac.dmg//' )"
    expectedTeamID="XCS435894D"
    ;;
