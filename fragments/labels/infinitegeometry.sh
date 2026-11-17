infinitegeometry)
    name="Infinite Geometry"
    type="dmg"
    if is-at-least 13 "$installedOSversion"; then
        kutaOS="macOS"
    else
        kutaOS="macOS_legacy"
    fi
    kutaVersion=$(getJSONValue "$(curl -fsL "https://cdn.kutasoftware.com/data/versions.json")" "retail.${kutaOS}.IGE")
    downloadURL="https://cdn.kutasoftware.com/retail/mac/IGE-Site-${kutaVersion}.dmg"
    appNewVersion=$(sed -E 's/\.0+([0-9])/.\1/g' <<< "$kutaVersion")
    expectedTeamID="2XHJ678JT7"
    ;;
