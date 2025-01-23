nvivo|\
nvivo15)
    name="NVivo 15"
    type="dmg"
    downloadURL="https://download.qsrinternational.com/Software/NVivo15forMac/NVivo15.dmg"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | awk -F'/' '{ print $6 }' | cut -d "." -f1-3)
    expectedTeamID="8F4S7H8S59"
    blockingProcesses=( NVivo NVivoHelper "Nvivo 15" )
    ;;
