vlc)
    name="VLC"
    type="dmg"
    appNewVersion=$(curl -fs https://download.videolan.org/pub/videolan/vlc/last/macosx/ | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    downloadURL="https://download.videolan.org/pub/videolan/vlc/last/macosx/vlc-${appNewVersion}-universal.dmg"
    expectedTeamID="75GAHG3SZQ"
    ;;
