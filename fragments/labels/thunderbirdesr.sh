thunderbirdesr)
    name="Thunderbird"
    type="dmg"
    versionKey="CFBundleShortVersionString"
    appNewVersion=$(curl -s "https://www.thunderbird.net/en-US/thunderbird/releases/atom.xml" | xmllint --xpath "//*[local-name()='entry']/*[local-name()='title'][contains(text(), 'esr')]/text()" - | head -1 | awk '{ print $2 }' | tr -d 'esr')
    downloadURL="https://download.mozilla.org/?product=thunderbird-${appNewVersion}esr-SSL&os=osx&lang=en-US"
    expectedTeamID="43AQ936H96"
    ;;
