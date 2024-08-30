vlc)
    # VLC is a versatile, open-source multimedia player that supports a wide range of audio, video, and streaming formats across multiple platforms
    name="VLC"
    type="dmg"
    appNewVersion=$(curl -s https://www.videolan.org/vlc/#download | xmllint --html --xpath "//script[contains(text(),'var PLATFORMS')]" - 2>/dev/null | grep -o '"osx":{"name":"macOS[^}]*' | grep -o '"latestVersion":"[^"]*' | sed 's/"latestVersion":"//')
    downloadURL="https://get.videolan.org/vlc/$appNewVersion/macosx/vlc-$appNewVersion-universal.dmg"
    expectedTeamID="75GAHG3SZQ"
    ;;
