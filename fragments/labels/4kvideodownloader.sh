4kvideodownloader)
    name="4K Video Downloader"
    type="dmg"
    sparkleData=$(curl -fsL "https://dl.4kdownload.com/app/appcast/videodownloader.xml")
    appNewVersion=$(xmllint --xpath 'normalize-space((//*[local-name()="enclosure" and @*[local-name()="os"]="mac-64"])[1]/@*[local-name()="version"])' - <<< "$sparkleData" | cut -d "." -f1-3)
    downloadURL="https://dl.4kdownload.com/app/4kvideodownloader_${appNewVersion}_x64.dmg?source=website"
    versionKey="CFBundleVersion"
    expectedTeamID="GHQ37VJF83"
    ;;
