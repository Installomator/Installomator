arctic)
    name="Arctic"
    type="zip"
    downloadURL=$(curl -fsL "https://updates.hedge.video/arctic/macos/appcast/arctic-prod.xml" | grep -oE 'url="https://[^"]+\.zip"' | head -1 | cut -d'"' -f2)
    appNewVersion=$(curl -fsL "https://updates.hedge.video/arctic/macos/appcast/arctic-prod.xml" | grep -oE 'sparkle:shortVersionString="[^"]+"' | head -1 | cut -d'"' -f2)
    expectedTeamID="A43D9X8EYU"
    blockingProcesses=( "Arctic" )
    ;;
