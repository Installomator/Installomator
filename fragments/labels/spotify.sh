spotify)
    name="Spotify"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://download.scdn.co/SpotifyARM64.dmg"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://download.scdn.co/Spotify.dmg"
    fi
    appNewVersion=$(curl -fs https://www.spotify.com/us/opensource/ | sed 's/","/\n/g' | grep "clientVersion" | sed -e 's/clientVersion":"\(.*\)"}.*bz2/\1/' | head -1 | awk -F "." '{print$1"."$2"."$3"."$4}')
    expectedTeamID="2FNC3A47ZF"
    ;;
