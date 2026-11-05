exacqvision)
    name="edvrclient"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -s "https://exacq.com/support/downloads.php?section=osx" | grep -oE 'https://[^"]+_arm64\.dmg' | head -n 1)
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -s "https://exacq.com/support/downloads.php?section=osx" | grep -oE 'https://[^"]+_x64\.dmg' | head -n 1)
    fi
    # the dmg filename carries a 4-part build (26.1.8.0); the app reports 3 parts (26.1.8)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*_([0-9.]+)_(arm64|x64)\.dmg/\1/' | cut -d. -f1-3)
    expectedTeamID="77CC7E9EL3"
    ;;
