4kvideodownloader)
    name="4K Video Downloader"
    type="dmg"
    downloadURL="$(curl -fsL "https://www.4kdownload.com/products/product-videodownloader" | grep -E -o "https:\/\/dl\.4kdownload\.com\/app\/4kvideodownloader_.*?.dmg\?source=website" | head -1)"
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/[0-9a-zA-Z]*_([0-9.]*)\.dmg.*/\1/g')
	versionKey="CFBundleVersion"
    expectedTeamID="GHQ37VJF83"
    ;;
