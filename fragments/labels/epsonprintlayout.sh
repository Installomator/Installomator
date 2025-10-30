epsonprintlayout)
    name="Epson Print Layout"
    type="pkgInDmg"
    downloadURL=$(curl -sL "https://epson.com/epson-print-layout" | grep -iEo 'https://ftp.epson.com/drivers/[^\"]+\.dmg' | head -n 1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*EPL_([0-9]+)\.dmg/\1/' | sed -E 's/^([0-9])([0-9])([0-9][0-9])$/\1.\2.\3/')
    expectedTeamID=TXAEAV5RN4
    ;;
