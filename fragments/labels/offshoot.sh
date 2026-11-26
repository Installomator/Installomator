offshoot)
    name="OffShoot"
    type="pkgInDmg"
    offshootFeed=$(curl -fsL "https://updates.hedge.video/hedge/macos/appcast/hedge-prod.xml")
    downloadURL=$(echo "$offshootFeed" | xpath 'string((//rss/channel/item)[1]/enclosure/@url)' 2>/dev/null)
    appNewVersion=$(echo "$offshootFeed" | xpath 'string((//rss/channel/item)[1]/enclosure/@sparkle:shortVersionString)' 2>/dev/null)
    pkgName="OffShoot Installer.pkg"
    expectedTeamID="A43D9X8EYU"
    blockingProcesses=( "OffShoot" "Hedge" )
    ;;
