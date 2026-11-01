operagx)
    name="Opera GX"
    type="dmg"
    appNewVersion=$(curl -fsL "https://get.geo.opera.com/pub/opera_gx/" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -1)
    downloadURL="https://get.geo.opera.com/pub/opera_gx/${appNewVersion}/mac/Opera_GX_${appNewVersion}_Setup.dmg"
    versionKey="CFBundleVersion"
    expectedTeamID="A2P9LX4JPN"
    ;;
