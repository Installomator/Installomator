opera)
    name="Opera"
    type="dmg"
    downloadURL="$(curl -fsIL "$(curl -fs "$(curl -fsL "https://download.opera.com/download/get/?partner=www&opsys=MacOS" | tr '"' "\n" | grep -e "www.opera.com.*thanks.*opera" | sed 's/\&amp\;/\&/g')" | tr '"' "\n" | grep "download.opera.com" | sed 's/\&amp\;/\&/g')" | grep -i "^location" | grep -io "https.*dmg")"
    appNewVersion="$(printf "$downloadURL" | sed -E 's/https.*\/([0-9.]*)\/mac\/.*/\1/')"
	versionKey="CFBundleVersion"
    expectedTeamID="A2P9LX4JPN"
    ;;
