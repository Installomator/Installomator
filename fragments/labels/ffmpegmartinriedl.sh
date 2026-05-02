ffmpegmartinriedl)
    name="FFmpeg"
    type="pkg"
    if [[ $(arch) == arm64 ]]; then
        archDir="arm64"
    else
        archDir="amd64"
    fi
    downloadURL="https://ffmpeg.martin-riedl.de/redirect/latest/macos/${archDir}/release/ffmpeg.pkg"
    appNewVersion=$( /usr/bin/curl -fs https://ffmpeg.martin-riedl.de/ | /usr/bin/awk '/Download Release Build/{found=1} found && /Release:/{match($0,/[0-9]+\.[0-9]+(\.[0-9]+)?/); print substr($0,RSTART,RLENGTH); exit}' )
    expectedTeamID="KU3N25YGLU"
    ;;
