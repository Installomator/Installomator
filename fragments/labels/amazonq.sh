amazonq)
	name="Amazon Q"
	type="dmg"
	downloadURL="https://desktop-release.q.us-east-1.amazonaws.com/latest/Amazon%20Q.dmg"
	appNewVersion=$(curl -sLI "https://github.com/aws/amazon-q-developer-cli-autocomplete/releases/latest" | grep -i "^location" | tr "/" "\n" | tail -1 | sed 's/[^0-9\.]//g')
	expectedTeamID="94KV3E626L"
	;;
