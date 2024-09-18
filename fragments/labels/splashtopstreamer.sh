splashtopstreamer)
    name="Splashtop Streamer"
    type="pkgInDmg"
    downloadURL=$(curl -fsLI "https://my.splashtop.com/csrs/mac" | grep -i '^location:' | tail -n 1 | cut -d ' ' -f 2 | tr -d '\r')
    appNewVersion=$(echo $downloadURL | sed -E 's/.*_v([0-9.]+).dmg/\1/')
    expectedTeamID="CPQQ3AW49Y"
    ;;
