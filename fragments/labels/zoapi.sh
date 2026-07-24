zoapiclient)
	name="Zoapi Client"
	type="dmg"
	appName="Zoapi.app"
	if [[ $(arch) == "arm64" ]]; then
		downloadURL="https://share.zoapi.com/zoapi/client/ZoapiClient-Setup.dmg"
	else
		printlog "Zoapi Client is only compatible with Apple Silicon (arm64) Macs." ERROR
		cleanupAndExit 95 "Zoapi Client requires Apple Silicon" ERROR
	fi
	appNewVersion=$(curl -fsL "https://share.zoapi.com/zoapi/v0/api/fetch/client/mac/latest-mac.yml" | grep "^version:" | sed 's/^version:[[:space:]]*\([0-9.]*\).*/\1/')
	expectedTeamID="WFY2HJH6B3"
	;;
