opera)
    name="Opera"
    type="dmg"
    downloadURL="https://get.geo.opera.com/ftp/pub/opera/desktop/"$( curl -fs "https://get.geo.opera.com/ftp/pub/opera/desktop/" | grep href | tail -1 | tr '"' '
' | grep "/" | head -1 )"mac/Opera_"$( curl -fs "https://get.geo.opera.com/ftp/pub/opera/desktop/" | grep href | tail -1 | tr '"' '
' | grep "/" | head -1 | sed -E 's/^([0-9.]*)\//\1/g' )"_Setup.dmg"
    appNewVersion="$( curl -fs "https://get.geo.opera.com/ftp/pub/opera/desktop/" | grep href | tail -1 | tr '"' '
' | grep "/" | head -1 | sed -E 's/^([0-9]*\.[0-9]*).*\//\1/g' )"
    expectedTeamID="A2P9LX4JPN"
    ;;
