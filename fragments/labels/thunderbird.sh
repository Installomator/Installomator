thunderbird)
    name="Thunderbird"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=thunderbird-latest&os=osx&lang=en-US"
    appNewVersion=$(curl -fsL "https://www.thunderbird.net/notes/" | grep -m 1 -o "Version [0-9\.]*" | awk '{print $2}')
    expectedTeamID="43AQ936H96"
    ;;
