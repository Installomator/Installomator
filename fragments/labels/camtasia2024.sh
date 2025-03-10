camtasia2024)
    name="Camtasia 2024"
    type="dmg"
    sparkleData=$(curl -fsL 'https://sparkle.cloud.techsmith.com/api/v1/AppcastManifest/?version=24.0.0&utm_source=product&utm_medium=cmac&utm_campaign=cm24&ipc_item_name=cmac&ipc_platform=macos')
    appNewVersion=$( <<<"$sparkleData" xpath 'string(//item[last()]/sparkle:shortVersionString)' )
    downloadURL=$( <<<"$sparkleData" xpath 'string(//item[last()]/enclosure/@url)' )
    expectedTeamID="7TQL462TU8"
    ;;
