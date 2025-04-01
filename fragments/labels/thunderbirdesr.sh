thunderbirdesr)
    name="Thunderbird"
    type="dmg"
    appNewVersion=$(curl -fsL "https://www.thunderbird.net/en-US/thunderbird/releases/atom.xml" | grep "esr" | grep -m 5 "<title type=" | sed 's/<.*>\(.*\)<.*>/\1/' | awk '{ print $2 }' | awk '{$1=$1};1' | tr -d "esr" | sort -V | tail -n1 )
    downloadURL="https://download.mozilla.org/?product=thunderbird-esr-latest&os=osx&lang=en-US"
    expectedTeamID="43AQ936H96"
    ;;
