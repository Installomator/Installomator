lunadisplay)
    name="Luna Display"
    type="dmg"
    downloadURL="https://downloads.astropad.com/luna/mac/latest"
    appNewVersion=$(curl -sI "${downloadURL}" | grep -o -E 'location:.*$' | grep -o -E '\d+\.\d+\.\d+\.\d+')
    appCustomVersion(){
        if [ -f "/Applications/Luna Display.app/Contents/Info.plist" ]; then
            firstPart=$(/usr/bin/defaults read "/Applications/Luna Display.app/Contents/Info.plist" "CFBundleShortVersionString")
            secondPart=$(/usr/bin/defaults read "/Applications/Luna Display.app/Contents/Info.plist" "CFBundleVersion")
            echo "$firstPart.$secondPart"
        fi
    }
    expectedTeamID="8356ZZ8Y5K"
    ;;
