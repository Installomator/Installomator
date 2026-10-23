ankerwork)
	name="AnkerWork"
	type="dmg"
	if [[ "$(arch)" == "arm64" ]]; then
		downloadURL="https://ankerwork.s3.us-west-2.amazonaws.com/electron/AnkerWork-Setup-arm64.dmg"
	else
		downloadURL="https://ankerwork.s3.us-west-2.amazonaws.com/electron/AnkerWork-Setup-x64.dmg"
	fi
	appNewVersion=$(curl -fsL "https://us.ankerwork.com/pages/download-software" | tr -d '\n' | grep -oE 'For Mac 10\.14 and above.*Headset Version' | grep -oE 'V[0-9]+\.[0-9]+\.[0-9]+' | head -1 | sed 's/^V//')
	expectedTeamID="BVL93LPC7F"
	;;
