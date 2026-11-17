coconutbattery)
    name="coconutBattery"
    type="zip"
    coconutXml=$(curl -sL "https://coconut-flavour.com/updates/coconutBattery_4.xml" | sed 's/ xmlns[^=]*="[^"]*"//g; s/sparkle://g')
    downloadURL=$(echo "$coconutXml" | xpath "string(//channel/item[not(channel)][1]/enclosure/@url)")
    appNewVersion=$(echo "$coconutXml" | xpath "string(//channel/item[not(channel)][1]/shortVersionString)")
    expectedTeamID="R5SC3K86L5"
    ;;
