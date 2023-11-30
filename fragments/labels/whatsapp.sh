whatsapp)
    name="WhatsApp"
    type="dmg"
    downloadURL="https://web.whatsapp.com/desktop/mac_native/release/?configuration=Release"
    expectedTeamID="57T9237FN3"
    appNewVersion=$(curl -s https://web.whatsapp.com/desktop/mac/releases | awk -F '"' '/"name"/ {print $4}')
    ;;
