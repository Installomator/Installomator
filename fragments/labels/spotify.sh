spotify)
    name="Spotify"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://download.scdn.co/SpotifyARM64.dmg"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://download.scdn.co/Spotify.dmg"
    fi
    # appNewVersion=$(curl -fs https://www.spotify.com/us/opensource/ | cat | grep -o "<td>.*.</td>" | head -1 | cut -d ">" -f2 | cut -d "<" -f1) # does not result in the same version as downloaded
    expectedTeamID="2FNC3A47ZF"
    ;;
