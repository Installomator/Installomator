snagit|\
snagit2026)
    name="Snagit"
    type="dmg"
    sparkleData=$(curl -H 'user-agent: Snagit/2026.0.0 Sparkle/2.8.0' -fsL 'https://sparkle.cloud.techsmith.com/api/v1/AppcastManifest/?version=26.0.1&utm_source=product&utm_medium=snagit&utm_campaign=sm2026&ipc_item_name=snagit&ipc_platform=macos')
    appNewVersion=$( <<<"$sparkleData" xpath '//*[local-name()="shortVersionString"] [starts-with(.,"2026.")] /text()' | tr ' ' '\n' | sort -V | tail -n1)
    downloadURL=$( <<<"$sparkleData" xpath 'string( //*[local-name()="item"] [./*[local-name()="shortVersionString"] = "'"$appNewVersion"'"] /*[local-name()="enclosure"]/@url)')
    expectedTeamID="7TQL462TU8"
    ;;
