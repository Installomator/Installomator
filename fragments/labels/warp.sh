warp)
    name="Warp"
    type="dmg"
    downloadURL="https://app.warp.dev/download"
    appNewVersion=$(curl -fs https://releases.warp.dev/channel_versions.json | grep -A 3 '"stable"' | grep '"version"' | head -n 1 | sed -E 's/.*"version": *"([^"]+)".*/\1/')
    expectedTeamID="2BBY89MBSN"
    versionKey="WarpVersion"
    ;;
