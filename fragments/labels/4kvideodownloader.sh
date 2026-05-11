4kvideodownloader)
    name="4K Video Downloader"
    type="dmg"
    videoDownloaderXML=$(curl -fsL https://dl.4kdownload.com/app/appcast/videodownloader.xml)
    appNewVersion=$(echo "$videoDownloaderXML" | xpath 'string(//rss/channel/item/enclosure/@sparkle:version)' | cut -d "." -f1-3)
    downloadURL="https://dl.4kdownload.com/app/4kvideodownloader_${appNewVersion}_x64.dmg?source=website"
    versionKey="CFBundleVersion"
    expectedTeamID="GHQ37VJF83"
    ;;
