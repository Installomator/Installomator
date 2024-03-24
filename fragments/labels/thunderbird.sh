thunderbird)
    name="Thunderbird"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=thunderbird-latest&os=osx&lang=en-US"
    appNewVersion=$(curl -fsL "https://www.thunderbird.net/en-US/thunderbird/releases/" | xmllint --html --xpath 'string(//aside/a[last()]/text())' - 2> /dev/null)
    expectedTeamID="43AQ936H96"
    ;;
