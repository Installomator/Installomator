minstaller)
    name="mInstaller"
    type="zip"
    mInstallerFeed=$(curl -fsL "https://s3.motionvfx.com/mvfxpublic/mInstaller/sparkle/appcast.xml")
    downloadURL=$(echo "$mInstallerFeed" | xpath 'string((//rss/channel/item)[1]/enclosure/@url)' 2>/dev/null)
    appNewVersion=$(echo "$mInstallerFeed" | xpath 'string((//rss/channel/item)[1]/sparkle:shortVersionString)' 2>/dev/null)
    expectedTeamID="MVBHMUPK33"
    ;;
