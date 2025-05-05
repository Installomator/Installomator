thunderbird)
    name="Thunderbird"
    type="dmg"
	appNewVersion=$(curl -I -s "https://download.mozilla.org/?product=thunderbird-esr-latest&os=osx&lang=en-US" | grep -i location | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1 )
    downloadURL="https://download.mozilla.org/?product=thunderbird-esr-latest&os=osx&lang=en-US"
    expectedTeamID="43AQ936H96"
    ;;
