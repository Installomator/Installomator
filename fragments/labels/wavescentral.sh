wavescentral)
    name="Waves Central"
    type="dmg"
    downloadURL="https://cf-installers.waves.com/WavesCentral/Install_Waves_Central.dmg"
    appNewVersion=$( curl -sf "https://register.waves.com/Autoupdate/Updates/ByProductId/1/central-mac" | grep version | cut -d" " -f2 | xargs )
    expectedTeamID="GT6E3XD798"
    ;;
