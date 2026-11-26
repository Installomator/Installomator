kalturacapture)
    name="KalturaCapture"
    type="dmg"
    downloadURL=$(curl -fsL "https://knowledge.kaltura.com/help/kaltura-capture-release-notes" | grep -o 'https://cdnapisec\.kaltura\.com/content/static/classroom/v[0-9][0-9.]*/KalturaCapture_[0-9][0-9.]*\.dmg' | sort -Vr | head -n 1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*KalturaCapture_([0-9.]+)\.dmg/\1/')
    expectedTeamID="X8RDCFJK95"
    ;;
