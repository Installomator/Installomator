warp)
    name="Warp"
    type="dmg"
    appNewVersion=$(curl -fsL "https://releases.warp.dev/channel_versions.json" | grep -o '"version": *"[^"]*\.stable_[^"]*"' | head -1 | sed 's/"version": *"//;s/"//')
    downloadURL="https://releases.warp.dev/stable/${appNewVersion}/Warp.dmg"
    appNewVersion="${appNewVersion#v}"
    expectedTeamID="2BBY89MBSN"
    ;;
