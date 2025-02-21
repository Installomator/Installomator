transmit5)
    name="Transmit"
    type="zip"
    downloadURL="https://download.panic.com/transmit/Transmit-5-Latest.zip"
    appNewVersion="$(curl -fsI "https://download.panic.com/transmit/Transmit-5-Latest.zip" | grep -i "^location" | sed -E 's/.*Transmit%20([0-9]+(\.[0-9]+)*)\.zip/\1/' | tr -d '\r')"
    expectedTeamID="VE8FC488U5"
    ;;

