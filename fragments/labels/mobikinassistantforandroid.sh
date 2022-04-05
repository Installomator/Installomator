mobikinassistantforandroid)
    name="MobiKin Assistant for Android"
    type="dmg"
    downloadURL="https://www.mobikin.com/downloads/mobikin-android-assistant.dmg"
    versionKey="CFBundleVersion"
    appNewVersion=$(curl -fs https://www.mobikin.com/assistant-for-android-mac/ | grep -i "version:" | sed -E 's/.*Version: ([0-9.]*)<.*/\1/g')
    expectedTeamID="YNL42PA5C4"
    ;;
