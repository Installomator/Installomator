coconutbattery)
    name="coconutBattery"
    type="zip"
    downloadURL="https://www.coconut-flavour.com/downloads/coconutBattery_4_latest.zip"
    appNewVersion=$(curl -fs https://www.coconut-flavour.com/coconutbattery/ | grep "<body" | sed -E 's/.*Download v([0-9+\.?]+).*/\1/')
    expectedTeamID="R5SC3K86L5"
    ;;
