ffmpegmartinriedl)
    name="FFmpeg"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        archDir="arm64"
    else
        archDir="amd64"
    fi
    downloadURL="https://ffmpeg.martin-riedl.de/redirect/latest/macos/${archDir}/release/ffmpeg.pkg"
    appNewVersion=$(curl -fsL -r 0-0 -o /dev/null -w '%{url_effective}' "$downloadURL" | sed -E 's#^.*/[0-9]+_([0-9]+(\.[0-9]+)+)/ffmpeg\.pkg$#\1#')
    appCustomVersion() { /usr/local/bin/ffmpeg -version 2>/dev/null | awk 'NR==1 { sub(/^ffmpeg version /, ""); sub(/-https:.*/, ""); print $1 }'; }
    expectedTeamID="KU3N25YGLU"
    blockingProcesses=( NONE )
    ;;
