ghostty)
    name="ghostty"
    type="dmg"
    appNewVersion="$(curl -fs "https://ghostty.org/download" | grep -E -io 'href="[^\"]+"' | grep -e "Ghostty.dmg" | awk -F\" '{print$2}' | sed -E 's/.*\/([0-9.]*)\/.*/\1/g')"
    downloadURL="https://release.files.ghostty.org/$appNewVersion/Ghostty.dmg"
    expectedTeamID="24VZTF6M5V"
    ;;
