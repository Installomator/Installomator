instantview)
    name="macOS InstantView"
    type="dmg"
    downloadURL=$(curl -fs "https://www.siliconmotion.com/downloads/" | grep -i macOS | grep "InstantView" | grep "dmg" | tr '"' '\n' | grep "dmg" | head -1)
    appNewVersion=$(echo $downloadURL | grep -oE "\d\.\d+R\d+" | sed 's/R/ R/g')
    expectedTeamID="JAGYSS7E9A"
    blockingProcesses=( "macOS InstantView" )
    ;;
