clickup)
	name="ClickUp"
	type="dmg"
	if [[ $(arch) == "arm64" ]]; then
		appNewVersion=$(curl -sD /dev/stdout https://desktop.clickup.com/mac/dmg/arm64 | grep filename | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
		downloadURL="https://desktop.clickup.com/mac/dmg/arm64"
	elif [[ $(arch) == "i386" ]]; then
        appNewVersion=$(curl -sD /dev/stdout https://desktop.clickup.com/mac | grep filename | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
        downloadURL="https://desktop.clickup.com/mac"
	fi
	expectedTeamID="5RJWFAUGXQ"
	;;
