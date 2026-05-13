livereplayer)
    name="LiveReplayer"
    type="pkg"
    downloadURL=$(curl -fsL https://fsm-livereplayer.s3.amazonaws.com/update/stable/latest.json | grep package-url | grep -o "https:.*.pkg")
    appNewVersion=$(echo ${downloadURL} | grep -o "LiveReplayer-.*" | grep -o "[0-9].*[0-9]")
    expectedTeamID="2H7P9E934F"
    ;;
