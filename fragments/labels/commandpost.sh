commandpost)
    name="CommandPost"
    type="dmg"
    downloadURL=$(curl -fsL https://api.github.com/repos/CommandPost/CommandPost/releases/latest | grep -oE '"browser_download_url": *"[^"]+CommandPost_[0-9.]+\.dmg"' | head -1 | cut -d'"' -f4)
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*CommandPost_([0-9.]+)\.dmg/\1/')
    expectedTeamID="A5HDJTY9X5"
    blockingProcesses=( "CommandPost" )
    ;;
