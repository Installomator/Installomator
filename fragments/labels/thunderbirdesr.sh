thunderbirdesr)
    name="Thunderbird"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=thunderbird-esr-latest&os=osx&lang=en-US"
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i Location | grep -o "/[0-9.]\+esr/" | grep -o "[0-9.]\+")
    expectedTeamID="43AQ936H96"
    ;;
