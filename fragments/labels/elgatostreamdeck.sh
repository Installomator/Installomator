elgatostreamdeck)
    name="Elgato Stream Deck"
    type="pkg"
    # packageID="com.elgato.StreamDeck"
	downloadURL="https://gc-updates.elgato.com/mac/sd-update/final/download-website.php"
    appNewVersion=$(curl -fsI "https://gc-updates.elgato.com/mac/sd-update/final/download-website.php" | grep -i ^location | sed -E 's/.*Stream_Deck_([0-9.]*).pkg/\1/g' | sed 's/\.[^.]*//3')
    expectedTeamID="Y93VXCB8Q5"
    blockingProcesses=( "Stream Deck" )
    ;;
