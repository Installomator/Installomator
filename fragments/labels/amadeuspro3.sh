amadeuspro3)
    name="Amadeus Pro 3"
    type="zip"
    amadeuspro3Feed=$(curl -fsL "https://s3.amazonaws.com/HairerSoftPublic/AmadeusPro3/AmadeusPro3.plist")
    downloadURL=$(echo "$amadeuspro3Feed" | plutil -extract 'productURL'  raw -o - -)
    appNewVersion=$(echo "$amadeuspro3Feed" | plutil -extract 'productVersion'  raw -o - -)
    expectedTeamID="FWDH9W45C2"
    ;;
