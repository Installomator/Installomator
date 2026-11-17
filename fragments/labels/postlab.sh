postlab)
    name="PostLab"
    type="pkgInDmg"
    downloadURL=$(curl -fsL "https://updates.hedge.video/postlab/macos/appcast/postlab-prod.xml" | grep -oE 'url="https://[^"]+\.dmg"' | head -1 | cut -d'"' -f2)
    appNewVersion=$(curl -fsL "https://updates.hedge.video/postlab/macos/appcast/postlab-prod.xml" | grep -oE 'sparkle:shortVersionString="[^"]+"' | head -1 | cut -d'"' -f2)
    packageID="video.hedge.PostLab.Mac"
    expectedTeamID="A43D9X8EYU"
    blockingProcesses=( "PostLab" )
    ;;
