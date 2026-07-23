zoapiclient)
	name="Zoapi Client"
	type="dmg"
	appName="Zoapi.app"
	ymlContent=$(curl -fsL "https://share.zoapi.com/zoapi/v0/api/fetch/client/mac/latest-mac.yml")
	appNewVersion=$(echo "$ymlContent" | grep "^version:" | sed 's/^version:[[:space:]]*\([0-9.]*\).*/\1/')
	sha512=$(echo "$ymlContent" | grep -A2 "url: ZoapiClient-Setup.dmg" | grep "sha512:" | sed 's/^[[:space:]]*sha512:[[:space:]]*//')
	downloadURL="https://share.zoapi.com/zoapi/client/ZoapiClient-Setup.dmg"
	expectedTeamID="WFY2HJH6B3"
	;;
