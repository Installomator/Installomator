opera)
    name="Opera"
    type="dmg"
	latest_ver=$(curl -fs https://get.geo.opera.com/pub/opera/desktop/ | grep -Eo 'href="[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/' | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)
	dmg_name=$(curl -fs https://get.geo.opera.com/pub/opera/desktop/$latest_ver/mac/ | grep -Eo 'href="[^"]+_Setup\.dmg"' | sed 's/href="//' | sed 's/"$//')
	downloadURL="https://get.geo.opera.com/pub/opera/desktop/$latest_ver/mac/$dmg_name"
	appNewVersion="$(printf "$downloadURL" | sed -E 's/https.*\/([0-9.]*)\/mac\/.*/\1/')"
	versionKey="CFBundleVersion"
    expectedTeamID="A2P9LX4JPN"
    ;;
