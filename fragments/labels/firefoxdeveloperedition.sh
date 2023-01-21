firefoxdeveloperedition)
    name="Firefox Developer Edition"
    type="dmg"
    downloadURL="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=osx&lang=en-US"
    appNewVersion=$(curl -fsIL "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=osx&lang=en-US&_gl=1*1g4sufp*_ga*OTAwNTc3MjE4LjE2NTM2MDIwODM.*_ga_MQ7767QQQW*MTY1NDcyNTYyNy40LjEuMTY1NDcyNzA2MS4w" | grep -i ^location | cut -d "/" -f7)
    expectedTeamID="43AQ936H96"
    ;;