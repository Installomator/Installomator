thunderbird)
    name="Thunderbird"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=thunderbird-latest&os=osx&lang=en-US"
    appNewVersion=$(curl -fsL "https://www.thunderbird.net/en-US/thunderbird/releases/atom.xml" | grep -v "esr" | grep -m 5 "<title type=" | sed 's/<.*>\(.*\)<.*>/\1/' | awk '{ print $2 }' | awk '{$1=$1};1' | sort -V | tail -n1 )
    expectedTeamID="43AQ936H96"
    ;;
