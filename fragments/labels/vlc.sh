vlc)
    name="VLC"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fs http://update.videolan.org/vlc/sparkle/vlc-arm64.xml | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null | cut -d '"' -f 2 )
        #appNewVersion=$(curl -fs http://update.videolan.org/vlc/sparkle/vlc-arm64.xml | xpath '//rss/channel/item[last()]/enclosure/@sparkle:version' 2>/dev/null | cut -d '"' -f 2 )
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fs http://update.videolan.org/vlc/sparkle/vlc-intel64.xml | xpath '//rss/channel/item[last()]/enclosure/@url' 2>/dev/null | cut -d '"' -f 2 )
        #appNewVersion=$(curl -fs http://update.videolan.org/vlc/sparkle/vlc-intel64.xml | xpath '//rss/channel/item[last()]/enclosure/@sparkle:version' 2>/dev/null | cut -d '"' -f 2 )
    fi
    appNewVersion=$(echo ${downloadURL} | sed -E 's/.*\/vlc-([0-9.]*).*\.dmg/\1/' )
    expectedTeamID="75GAHG3SZQ"
    ;;
