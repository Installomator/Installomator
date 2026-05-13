hudlstudio)
    name="Studio"
    type="dmg"
    appNewVersion=$(curl -fs https://www.hudl.com/downloads/elite | grep -A 1 "Download Studio" | grep -o -e "[0-9.]*")
    downloadURL="https://studio-releases.s3.amazonaws.com/Studio-$appNewVersion.dmg"
	versionKey="CFBundleVersion"
    expectedTeamID="2YLQ7PASUE"
    ;;
