offshoot)
    name="OffShoot"
    type="pkgInDmg"
    downloadURL=$(curl -fsL "https://updates.hedge.video/hedge/macos/appcast/hedge-prod.xml" | grep -oE 'url="https://[^"]+\.dmg"' | head -1 | cut -d'"' -f2)
    appNewVersion=$(curl -fsL "https://updates.hedge.video/hedge/macos/appcast/hedge-prod.xml" | grep -oE 'sparkle:shortVersionString="[^"]+"' | head -1 | cut -d'"' -f2)
    pkgName="OffShoot Installer.pkg"
    expectedTeamID="A43D9X8EYU"
    blockingProcesses=( "OffShoot" "Hedge" )
    ;;
