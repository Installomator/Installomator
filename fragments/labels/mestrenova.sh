mestrenova)
    name="MestReNova"
    type="dmg"
    mestrenovaFeed=$(curl -fsL "https://mestrelab.com/mnova-auto-upgrade-service")
    downloadURL=$(echo "$mestrenovaFeed" | xpath '(//Products/Product[Platform="Mac"]/URL)[1]/text()' 2>/dev/null | sed 's|^http://|https://|')
    appNewVersion=$(echo "$mestrenovaFeed" | xpath '(//Products/Product[Platform="Mac"]/Version)[1]/text()' 2>/dev/null)
    expectedTeamID="DH5EKRR34H"
    ;;
