instantview)
    name="macOS InstantView"
    type="dmg"
    downloadURL=$(curl "https://www.siliconmotion.com/downloads/" | grep -i macOS | grep "InstantView" | grep "dmg" | tr '"' '\n' | grep "dmg" | head -1)
    expectedTeamID="JAGYSS7E9A"
    blockingProcesses=( "macOS InstantView" )
    ;;