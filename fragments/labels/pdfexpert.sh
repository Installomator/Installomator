pdfexpert)
    # PDF Expert
    name="PDF Expert"
    type="zip"
    downloadURL=$(curl -fs "https://downloads.pdfexpert.com/pem3/release/appcast.xml" | grep -o 'https://downloads.pdfexpert.com/[^"]*.zip' | tail -n 1)
    appNewVersion=$(curl -fs "https://downloads.pdfexpert.com/pem3/release/appcast.xml" | grep -o 'sparkle:shortVersionString="[^"]*"' | sed -E 's/sparkle:shortVersionString="([^"]*)"/\1/' | tail -n 1)
    expectedTeamID="3L68KQB4HG"
    ;;
