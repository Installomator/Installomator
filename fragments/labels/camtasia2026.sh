camtasia|\
camtasia2026)
    name="Camtasia"
    type="dmg"
    sparkleData=$(curl -H 'user-agent: Camtasia/2026.0.7 Sparkle/2.8.0' \
        -fsL 'https://sparkle.cloud.techsmith.com/api/v1/AppcastManifest/?version=26.0.0&utm_source=product&utm_medium=cmac&utm_campaign=cm26&ipc_item_name=cmac&ipc_platform=macos')
    appNewVersion=$( <<<"$sparkleData" xpath \
        '//*[local-name()="shortVersionString"]
            [starts-with(.,"2026.")]
            /text()' \
        | tr ' ' '\n' | sort -V | tail -n1
    )
    downloadURL=$( <<<"$sparkleData" xpath \
        'string(
            //*[local-name()="item"]
            [./*[local-name()="shortVersionString"] = "'"$appNewVersion"'"]
            /*[local-name()="enclosure"]/@url
        )'
    )
    expectedTeamID="7TQL462TU8"
    ;;
