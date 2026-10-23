opera)
    name="Opera"
    type="dmg"
    appNewVersion=$(curl -fs "https://get.geo.opera.com/pub/opera/desktop/" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -1)
    downloadURL="https://get.geo.opera.com/pub/opera/desktop/${appNewVersion}/mac/Opera_${appNewVersion}_Setup.dmg"
    versionKey="CFBundleVersion"
    expectedTeamID="A2P9LX4JPN"
    ;;
