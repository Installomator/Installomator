whatsapp)
    name="WhatsApp"
    type="dmg"
    downloadURL="https://web.whatsapp.com/desktop/mac_native/release/?configuration=Release"
<<<<<<< HEAD
=======
    appNewVersion=$(curl -fsLIXGET "https://web.whatsapp.com/desktop/mac_native/release/?configuration=Release" | grep -i "^location" | grep -m 1 -o "WhatsApp-.*dmg" | sed 's/.*WhatsApp-2.//g' | sed 's/.dmg//g')
>>>>>>> pr/1369
    expectedTeamID="57T9237FN3"
    appNewVersion=$(curl -s https://web.whatsapp.com/desktop/mac/releases | awk -F '"' '/"name"/ {print $4}')
    ;;
