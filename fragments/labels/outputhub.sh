outputhub)
    name="Output Hub"
    type="dmg"
	downloadURL="$(curl -fs "https://output.com/hub"| grep "Mac Download" | cut -d\" -f4)"
    appNewVersion=$( curl -fs "https://output-hub-builds.s3.amazonaws.com/latest-mac.yml" | grep "^version:" | cut -d" " -f2 )
    expectedTeamID="M4BQRFQ23V"
    ;;