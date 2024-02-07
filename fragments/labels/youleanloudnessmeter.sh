youleanloudnessmeter2)
    name="Youlean Loudness Meter 2"
    type="pkgInZip"
    #downloadURL="https://cdn.youlean.co/wp-content/uploads/2023/03/Youlean-Loudness-Meter-2-V2.4.4-macOS.zip"
    downloadURL=$(curl -fs "https://youlean.co/download-youlean-loudness-meter/" | grep macOS | grep -oE "https:.*-macOS.zip" | head -1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*-V([0-9.]*)-macOS.zip/\1/')
    expectedTeamID="S7KN6P3F95"
    ;;
