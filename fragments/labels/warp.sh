warp)
    name="Warp"
    type="dmg"
    downloadURL="https://app.warp.dev/download"
    appNewVersion=$(curl -fs "https://app.warp.dev/download?package=dmg" | grep -o 'v[0-9]\.[0-9]\{4\}\.[0-9]\{2\}\.[0-9]\{2\}\.[0-9]\{2\}\.[0-9]\{2\}\.stable_[0-9]\{2\}')
    expectedTeamID="2BBY89MBSN"
    versionKey="WarpVersion"
    ;;
