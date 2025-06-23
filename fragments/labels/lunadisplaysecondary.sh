lunadisplaysecondary)
    name="Luna Secondary"
    type="dmg"
    downloadURL="https://downloads.astropad.com/luna-secondary/mac/latest"
    appNewVersion=$(curl -sI "${downloadURL}" | grep -o -E 'location:.*$' | grep -o -E '\d+\.\d+\.\d+\.\d+')
    appCustomVersion(){
        if [ -f "/Applications/Luna Secondary.app/Contents/Info.plist" ]; then
            firstPart=$(/usr/bin/defaults read "/Applications/Luna Secondary.app/Contents/Info.plist" "CFBundleShortVersionString")
            secondPart=$(/usr/bin/defaults read "/Applications/Luna Secondary.app/Contents/Info.plist" "CFBundleVersion")
            echo "$firstPart.$secondPart"
        fi
    }
    expectedTeamID="8356ZZ8Y5K"
    ;;
