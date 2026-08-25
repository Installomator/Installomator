warp)
    name="Warp"
    type="dmg"
    warpJSON=$(curl -fsL "https://releases.warp.dev/channel_versions.json")
    appNewVersion=$(getJSONValue "$warpJSON" "stable.version")
    downloadURL="https://releases.warp.dev/stable/${appNewVersion}/Warp.dmg"
    appNewVersion="${appNewVersion#v}"
    appNewVersion="${appNewVersion/.stable_/.}"
    expectedTeamID="2BBY89MBSN"
    ;;
