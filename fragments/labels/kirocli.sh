kirocli)
    name="Kiro CLI"
    type="dmg"
    downloadURL="https://desktop-release.q.us-east-1.amazonaws.com/latest/Kiro%20CLI.dmg"
    appNewVersion=$(curl -fsL "https://desktop-release.q.us-east-1.amazonaws.com/latest/manifest.json" | grep -o '"version": "[^"]*"' | head -1 | cut -d'"' -f4)
    expectedTeamID="94KV3E626L"
    ;;
