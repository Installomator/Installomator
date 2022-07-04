vlc)
    name="VLC"
    type="dmg"
    releaseURL="https://download.videolan.org/pub/videolan/vlc/last/macosx/"
    if [[ $(arch) == "arm64" ]]; then
    	appNewVersion=$(curl -sf $releaseURL | grep -m 1 "arm64.dmg" | sed "s|.*vlc-\(.*\)-arm64.*|\\1|")
        downloadURL="https://download.videolan.org/pub/videolan/vlc/last/macosx/vlc-"$appNewVersion"-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
    	appNewVersion=$(curl -sf $releaseURL | grep -m 1 "intel64.dmg" | sed "s|.*vlc-\(.*\)-intel64.*|\\1|")
        downloadURL="https://download.videolan.org/pub/videolan/vlc/last/macosx/vlc-"$appNewVersion"-intel64.dmg"
    fi
    expectedTeamID="75GAHG3SZQ"
    ;;
