coconutbattery)
    name="coconutBattery"
    type="zip"
    downloadURL="https://coconut-flavour.com/downloads/coconutBattery_latest.zip"
    appNewVersion=$(curl -fs https://www.coconut-flavour.com/coconutbattery/ | grep "<body>" | sed 's/.*Release Notes - v\([^ ]*\) .*/\1/')
    expectedTeamID="R5SC3K86L5"
    ;;
