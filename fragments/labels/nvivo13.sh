nvivo13)
    name="NVivo"
    type="dmg"
    downloadURL="https://download.qsrinternational.com/Software/NVivoforMac/NVivo.dmg"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | tr '/' '\n' | grep "[0-9]" | cut -d "." -f1-3 )
    expectedTeamID="A66L57342X"
    blockingProcesses=( NVivo NVivoHelper )
    ;;
