4kvideodownloaderplus)
    name="4K Video Downloader+"
    type="dmg"
    downloadURL="$(curl -Ls "https://www.4kdownload.com/downloads" | grep dmg | cut -d '"' -f 4 | grep -e videodownloaderplus | cut -d '?' -f 1)"
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/[0-9a-zA-Z]*_([0-9.]*)\.dmg.*/\1/g')
    versionKey="CFBundleVersion"
    expectedTeamID="GHQ37VJF83"
    ;;
