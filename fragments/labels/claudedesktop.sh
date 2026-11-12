claudedesktop)
    name="Claude"
    type="zip"
    releaseFeed=$(curl -fsL "https://downloads.claude.ai/releases/darwin/universal/RELEASES.json")
    appNewVersion=$(getJSONValue "${releaseFeed}" "currentRelease")
    downloadURL=$(getJSONValue "${releaseFeed}" "releases[0].updateTo.url")
    expectedTeamID="Q6L2SF6YDW"
    blockingProcesses=( "Claude" "Claude Helper" )
    ;;
