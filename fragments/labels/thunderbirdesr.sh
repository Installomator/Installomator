thunderbirdesr)
    name="Thunderbird"
    type="dmg"
    esrVersion=$(curl -fsL "https://www.thunderbird.net/en-US/thunderbird/releases/atom.xml" | grep -m 1 "<title type=" | sed 's/<.*>\(.*\)<.*>/\1/' | awk '{ print $2 }' | awk '{$1=$1};1')
    appNewVersion=${esrVersion%esr}
    downloadURL="https://download.mozilla.org/?product=thunderbird-$esrVersion-SSL&os=osx&lang=en-US"
    expectedTeamID="43AQ936H96"
    ;;