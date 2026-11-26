tentaclesyncstudio)
    name="Tentacle Sync Studio"
    type="dmg"
    tentacleFile=$(curl -fsL -A "Mozilla/5.0" https://tentaclesync.com/downloads/tentacle-sync-studio-macos | grep -oE 'ttsyncstudio-v[0-9]+_[0-9]+\.dmg' | sort -u -t_ -k2,2n | tail -1)
    downloadURL="https://cms.tentaclesync.com/assets/downloads/download-files/${tentacleFile}"
    appNewVersion=$(echo "${tentacleFile}" | sed -E 's/ttsyncstudio-v([0-9]+)_([0-9]+)\.dmg/\1.\2/')
    expectedTeamID="N3J7Y6A64Z"
    ;;
