claricopilot)
	name="Clari Copilot"
	type="dmg"
	appName="Clari-Copilot.app"
	expectedTeamID="AN4U5AWX9M"
	appNewVersion=$(curl -sL "https://strings-rta-public.s3.us-east-1.amazonaws.com/enterprise/latest-mac.yml" | grep "^version:" | sed 's/^version:[[:space:]]*\([0-9.]*\).*/\1/')
	downloadURL="https://strings-rta-public.s3.us-east-1.amazonaws.com/enterprise/Clari-Copilot-${appNewVersion}.dmg"
	;;
