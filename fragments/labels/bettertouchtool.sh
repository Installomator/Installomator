bettertouchtool)
    # credit: Søren Theilgaard (@theilgaard)
    name="BetterTouchTool"
    type="zip"
    downloadURL="https://folivora.ai/releases/BetterTouchTool.zip"
    appNewVersion=$(curl -fsL "https://folivora.ai/releases/" | grep 'Current stable build' | head -n 1 | sed -E 's/.*href="btt([0-9.]+)-[0-9]+\.zip".*/\1/')
    expectedTeamID="DAFVSXZ82P"
    ;;
