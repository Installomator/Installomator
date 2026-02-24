claudedesktop)
    name="Claude"
    type="zip"
    appNewVersion=$(curl -fs "https://downloads.claude.ai/releases/darwin/universal/RELEASES.json" | grep -o '"currentRelease":"[^"]*"' | cut -d'"' -f4)
    downloadURL=$(curl -fs "https://downloads.claude.ai/releases/darwin/universal/RELEASES.json" | grep -o '"url":"[^"]*"' | cut -d'"' -f4)
    expectedTeamID="Q6L2SF6YDW"
    blockingProcesses=( "Claude" )
    ;;
