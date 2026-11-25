royaltsx)
    name="Royal TSX"
    type="dmg"
    sparkleData=$(curl -fsL "https://royaltsx-v6.royalapps.com/updates_stable")
    downloadURL=$(echo "$sparkleData" | grep -o 'enclosure url="[^"]*"' | head -1 | cut -d '"' -f 2)
    appNewVersion=$(echo "$sparkleData" | grep -o 'sparkle:shortVersionString="[^"]*"' | head -1 | cut -d '"' -f 2)
    expectedTeamID="VXP8K9EDP6"
    ;;
