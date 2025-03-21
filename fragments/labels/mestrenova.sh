mestrenova)
    name="MestReNova"
    type="dmg"
    mestrenovaDownloadVersion=$(curl -fs "https://mestrelab.com/download" | grep -Ei '([0-9]+.){2}[0-9]-[0-9]{5}' | head -n 1 | sed -E 's/.*-([0-9]+.[0-9]+.[0-9]+-[0-9]{5}).*/\1/g')
    downloadURL="https://mestrelab.com/downloads/mnova/mac/MestReNova-$mestrenovaDownloadVersion.dmg"
    appNewVersion=$(echo "$mestrenovaDownloadVersion" | cut -d '-' -f1)
    expectedTeamID="DH5EKRR34H"
    ;;
