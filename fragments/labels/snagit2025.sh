snagit|\
snagit2025)
	name="Snagit"
	type="dmg"
	sparkleData=$(curl -fsL 'https://sparkle.cloud.techsmith.com/api/v1/AppcastManifest/?version=2025.0.0&utm_source=product&utm_medium=snagit&utm_campaign=sm2025&ipc_item_name=snagit&ipc_platform=macos')
	appNewVersion=$( <<<"$sparkleData" xpath 'string(//item[last()]/sparkle:shortVersionString)' )
	downloadURL=$( <<<"$sparkleData" xpath 'string(//item[last()]/enclosure/@url)' )
	expectedTeamID="7TQL462TU8"
	;;
