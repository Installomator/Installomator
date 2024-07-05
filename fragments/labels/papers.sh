papers)
    name="Papers"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.readcube.com/app/Papers_Setup-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.readcube.com/app/Papers_Setup-x64.dmg"
    fi
    latestReleaseNote="$(curl -fsL "https://support.papersapp.com/support/solutions/folders/30000056499" | grep -oE "href=\".*-release-notes-.*\"" | cut -d '"' -f 2 | head -1)"
    appNewVersion="$(curl -fsL "https://support.papersapp.com${latestReleaseNote}" | xmllint --html --xpath 'string(//div[@itemprop="articleBody"]/p/span[@dir="ltr"])' - 2> /dev/null | awk -F' ' '{ print $(NF) }')"
    expectedTeamID="FY6R4ETYH7"
    ;;
