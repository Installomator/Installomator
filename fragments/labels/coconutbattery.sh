coconutbattery)
    name="coconutBattery"
    type="zip"
    downloadURL="https://coconut-flavour.com/downloads/coconutBattery_latest.zip"
    appNewVersion=$(curl -fs https://www.coconut-flavour.com/coconutbattery/ | grep "<title>" | sed -e  's/.*coconutBattery \(.*\) - by coconut-flavour.co.*/\1/')
    expectedTeamID="R5SC3K86L5"
    ;;
