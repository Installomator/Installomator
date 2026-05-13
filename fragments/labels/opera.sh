opera)
    name="Opera"
    type="dmg"
    downloadURL="$(curl -fsIL $(curl -fsL $(curl -fsI "https://download.opera.com/download/get/?partner=www&opsys=MacOS" | grep -i "^location" | awk '{print $2}' | tr -d '\r') | grep -oE "https:\/\/download\.opera\.com\/[^\"]*" | sed 's/\&amp\;/\&/g') | grep -i "^location" | awk '{print $2}' | tr -d '\r')"
    appNewVersion="$(printf "$downloadURL" | sed -E 's/https.*\/([0-9.]*)\/mac\/.*/\1/')"
	versionKey="CFBundleVersion"
    expectedTeamID="A2P9LX4JPN"
    ;;
