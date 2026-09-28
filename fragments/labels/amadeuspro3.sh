amadeuspro3)
    name="Amadeus Pro 3"
    type="zip"
    downloadURL="https://s3.amazonaws.com/HairerSoftPublic/AmadeusPro3/AmadeusPro.zip"
    appNewVersion=$(curl -fsL "https://www.hairersoft.com/pro.html" | sed -nE '/Download Amadeus.*for macOS/{s/<[^>]*>/ /g;s/.*Pro +([0-9]+(\.[0-9]+)+) for macOS.*/\1/p;q;}')
    expectedTeamID="FWDH9W45C2"
    ;;