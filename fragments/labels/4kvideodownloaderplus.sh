4kvideodownloaderplus)
    name="4K Video Downloader+"
    type="dmg"
    sparkleData=$(curl -fsL "https://dl.4kdownload.com/app/appcast/videodownloaderplus.xml")
    appNewVersion=$(xmllint --xpath 'normalize-space((//*[local-name()="enclosure" and @*[local-name()="os"]="mac-64"])[1]/@*[local-name()="version"])' - <<< "$sparkleData" | cut -d "." -f1-3)
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://dl.4kdownload.com/app/4kvideodownloaderplus_${appNewVersion}_arm64.dmg?source=website"
    else
        downloadURL="https://dl.4kdownload.com/app/4kvideodownloaderplus_${appNewVersion}_x64.dmg?source=website"
    fi
    versionKey="CFBundleVersion"
    expectedTeamID="GHQ37VJF83"
    ;;
