amadeuspro2)
    # A powerful audio editing tool for macOS, offering multi-track editing, batch processing, and a variety of sound analysis features
    name="Amadeus Pro"
    type="zip"
    downloadURL="https://s3.amazonaws.com/AmadeusPro2/AmadeusPro.zip"
    appNewVersion=$(curl -fs "https://www.hairersoft.com/pro.html" | grep -ioE "version[: ]+[0-9]+\.[0-9]+(\.[0-9]+)?" | head -1 | grep -oE "[0-9]+\.[0-9]+(\.[0-9]+)?")
    expectedTeamID="FWDH9W45C2"
    ;;
