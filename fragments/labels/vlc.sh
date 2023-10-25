vlc)
    name="VLC"
    type="dmg"
    downloadURL="https://download.videolan.org/pub/videolan/vlc/last/macosx/vlc-$(curl -fs https://download.videolan.org/pub/videolan/vlc/last/macosx/ | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -1)-universal.dmg"
    appNewVersion=$(curl -fs https://download.videolan.org/pub/videolan/vlc/last/macosx/ | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    expectedTeamID="75GAHG3SZQ"
    ;;
