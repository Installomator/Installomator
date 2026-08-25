obsioscamera)
    name="iOS Camera for OBS Studio"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="$(curl -fsL https://obs.camera/docs/getting-started/ios-camera-plugin-usb/ | tr '>' '\n' | grep -oE 'https://github.com/.*arm64.pkg' | sort | tail -1)"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="$(curl -fsL https://obs.camera/docs/getting-started/ios-camera-plugin-usb/ | tr '>' '\n' | grep -oE 'https://github.com/.*x86_64.pkg' | sort | tail -1)"
    fi
    appNewVersion=$(echo $downloadURL | grep -oe "-[0-99].[0-99].[0-99]-" | sed 's|-||g')
    appCustomVersion(){
      defaults read "/Library/Application Support/obs-studio/plugins/obs-ios-camera-source.plugin/Contents/Info.plist" CFBundleVersion
    }
    expectedTeamID="DQA7HX6GV3"
    ;;
