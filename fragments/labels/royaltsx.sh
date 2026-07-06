royaltsx)
    name="Royal TSX"
    type="dmg"
    sparkleData=$(curl -fsL "https://royaltsx-v6.royalapps.com/updates_stable")
    downloadURL=$(echo "$sparkleData" | grep -m1 -oE 'url="[^"]+"' | cut -d '"' -f 2)
    appNewVersion=$(echo "$sparkleData" | grep -m1 -oE 'sparkle:shortVersionString="[^"]+"' | cut -d '"' -f 2)
    expectedTeamID="VXP8K9EDP6"
    ;;
