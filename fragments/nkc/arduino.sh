arduino)
    # NKC Change
    name="arduino"
    type="dmg"
    appNewVersion=$(curl -s -L https://www.arduino.cc/en/software | egrep -o 'https?://[^ ]+' | grep "arm64" | cut -f 2 -d '_')
    downloadURL=$(curl -s -L https://www.arduino.cc/en/software | egrep -o 'https?://[^ ]+' | grep "arm64" | cut -f 1 -d '"')
    expectedTeamID="7KT7ZWMCJT"
    appName="Arduino IDE.app"
    ;;
