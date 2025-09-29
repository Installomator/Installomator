4kvideodownloader)
    name="4K Video Downloader"
    type="dmg"
    appNewVersion=$(curl -fsL "https://www.4kdownload.com/downloads/34" | grep -E -o "https:\/\/dl\.4kdownload\.com\/app\/4kvideodownloader_.*?.exe\?source=website" | head -1 | cut -d "_" -f2)
    downloadURL="https://dl.4kdownload.com/app/4kvideodownloader_${appNewVersion}_x64.dmg?source=website"
	versionKey="CFBundleVersion"
    expectedTeamID="GHQ37VJF83"
    ;;
