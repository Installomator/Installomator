thinlincclient)
    name="ThinLinc Client"
    type="dmg"
    downloadURL=$(curl -fsL "https://www.cendio.com/thinlinc/download/" | grep -Eo 'https://www\.cendio\.com/downloads/clients/tl-[0-9]+(\.[0-9]+)+_[0-9]+-client-macos\.dmg' | head -1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's|.*/tl-([0-9]+(\.[0-9]+)+)_[0-9]+-client-macos\.dmg$|\1|')
    expectedTeamID="PHUT6TWL4H"
    ;;
