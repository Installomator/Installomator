nvivo|\
nvivo15)
    name="NVivo"
    type="dmg"
    downloadURL=$(curl -fsIL -o /dev/null -w "%{url_effective}" "https://download.qsrinternational.com/Software/NVivo15forMac/NVivo15.dmg")
    appNewVersion=$(printf '%s\n' "$downloadURL" | sed -nE 's#^https://download\.qsrinternational\.com/Software/NVivo15forMac/(15\.[0-9]+\.[0-9]+)\.[0-9]+/[^/]+\.dmg([?].*)?$#\1#p')
    expectedTeamID="8F4S7H8S59"
    blockingProcesses=( NVivo NVivoHelper "Nvivo 15" )
    ;;
