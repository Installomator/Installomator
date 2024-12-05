synergyvideoexpress)
    name="Synergy Video Express"
    type="dmg"
    relativeDownloadURL="$(curl -fsL https://www.synergysportstech.com/apps/videoexpress/production/macOS/default.htm | grep -Eo 'Synergy_Video_Express_[^"]+\.dmg' | head -1)"
    downloadURL="https://www.synergysportstech.com/apps/videoexpress/production/macOS/${relativeDownloadURL}"
    appNewVersion=$(echo "$relativeDownloadURL" | sed -E 's/.*_([0-9]+_[0-9]+_[0-9]+_[0-9]+)\.dmg/\1/' | tr '_' '.')
    expectedTeamID="BATB6XS52B"
    appName="Synergy Video Express.app"
    blockingProcesses=( "Synergy Video Express" )
    ;;
