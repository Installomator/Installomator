4kvideodownloaderplus)
    name="4K Video Downloader+"
    type="dmg"
    if [[ $(/usr/bin/arch) == "arm64" ]]; then 
        downloadURL="$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36" -fsL "https://www.4kdownload.com/downloads/34" | grep -E -o "https:\/\/dl\.4kdownload\.com\/app\/4kvideodownloaderplus.*arm64.*?.dmg\?source=website" | head -1)"
    else
        downloadURL="$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36" -fsL "https://www.4kdownload.com/downloads/34" | grep -E -o "https:\/\/dl\.4kdownload\.com\/app\/4kvideodownloaderplus.*x64.*?.dmg\?source=website" | head -1)"
    fi
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/[0-9a-zA-Z]*_([0-9.]*)_arm64\.dmg.*/\1/g')
	versionKey="CFBundleVersion"
    expectedTeamID="GHQ37VJF83"
    ;;
