bettertouchtool)
    # credit: Søren Theilgaard (@theilgaard)
    name="BetterTouchTool"
    type="zip"
    downloadURL="https://folivora.ai/releases/BetterTouchTool.zip"
    appNewVersion=$(curl -fs https://folivora.ai/releases/ | grep btt | head -n1 | tail -n 1 | awk '{print $6}' | sed 's/^[^>>]*>//' | sed "s/\-.*//" | cut -c 4-)
    expectedTeamID="DAFVSXZ82P"
    ;;
