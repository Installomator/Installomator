spotify)
    name="Spotify"
    type="dmg"
    downloadURL="https://download.scdn.co/Spotify.dmg"
    # appNewVersion=$(curl -fs https://www.spotify.com/us/opensource/ | cat | grep -o "<td>.*.</td>" | head -1 | cut -d ">" -f2 | cut -d "<" -f1) # does not result in the same version as downloaded
    expectedTeamID="2FNC3A47ZF"
    ;;
