tuple)
    name="Tuple"
    type="zip"
    downloadURL=$(curl -fs "https://d32ifkf9k9ezcg.cloudfront.net/production/sparkle/appcast.xml" | grep -o 'https://d32ifkf9k9ezcg.cloudfront.net/[^"]*.zip' | head -n 1)
    appNewVersion=$(curl -fs "https://d32ifkf9k9ezcg.cloudfront.net/production/sparkle/appcast.xml" | grep -o 'sparkle:shortVersionString="[^"]*"' | sed -E 's/sparkle:shortVersionString="([^"]*)"/\1/' | head -n 1)
    expectedTeamID="DQYU7DR9Q7"
    ;;
