spotify)
    name="Spotify"
    type="dmg"
    tmpSpotifyDir=$(mktemp -d)
    zipSpotifyPath="$tmpSpotifyDir/SpotifyInstaller.zip"
    curl -fsSL "https://download.scdn.co/SpotifyInstaller.zip" -o "$zipSpotifyPath"
    unzip -q "$zipSpotifyPath" -d "$tmpSpotifyDir"
    appNewVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$tmpSpotifyDir/Install Spotify.app/Contents/Info.plist")
    rm -rf "$tmpSpotifyDir"
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://download.scdn.co/SpotifyARM64.dmg"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://download.scdn.co/Spotify.dmg"
    fi
    expectedTeamID="2FNC3A47ZF"
    ;;
