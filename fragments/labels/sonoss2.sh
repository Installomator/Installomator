sonoss2)
    name="Sonos"
    type="dmg"
    downloadURL="https://www.sonos.com/redir/controller_software_mac2"
    appNewVersion=$(curl -LIs -o /dev/null -w "%{url_effective}\n" "$downloadURL" | grep -oE '[0-9]+\.[0-9]+-[0-9]+' | tr '-' '.')
    versionKey="CFBundleVersion"
    expectedTeamID="2G4LW83Q3E"
    ;;
