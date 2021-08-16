opera)
    name="Opera"
    type="dmg"
    downloadURL=$(curl -fsIL "$(curl -fs "$(curl -fsIL "https://download.opera.com/download/get/?partner=www&opsys=MacOS" | grep -i "^location" | cut -d " " -f2 | tail -1 | tr -d '\r')" | grep download.opera.com | grep -io "https.*yes" | sed 's/\&amp;/\&/g')" | grep -i "^location" | cut -d " " -f2 | tr -d '\r')
    appNewVersion="$(curl -fs "https://get.geo.opera.com/ftp/pub/opera/desktop/" | grep "href=\"\d" | sort -V | tail -1 | tr '"' '\n' | grep "/" | head -1 | tr -d '/')"
	versionKey="CFBundleVersion"
    expectedTeamID="A2P9LX4JPN"
    ;;
