camtasia2023)
    name="Camtasia 2023"
    type="dmg"
    sparkleData=$(curl -fsL 'https://sparkle.cloud.techsmith.com/api/v1/AppcastManifest/?version=23.0.0&utm_source=product&utm_medium=cmac&utm_campaign=cm23&ipc_item_name=cmac&ipc_platform=macos')
    appNewVersion=$( <<<"$sparkleData" xpath 'string(//item/sparkle:shortVersionString)' )
    downloadURL=$( <<<"$sparkleData" xpath 'string(//item/enclosure/@url)' )
    expectedTeamID="7TQL462TU8"
    ;;
