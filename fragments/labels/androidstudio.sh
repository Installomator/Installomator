androidstudio)
    name="Android Studio"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        downloadURL=$(curl -fsL "https://developer.android.com/studio#downloads" | grep -i arm.dmg | head -2 | grep -o -i -E "https.*" | cut -d '"' -f1)
    elif [[ $(arch) == i386 ]]; then
        downloadURL=$(curl -fsL "https://developer.android.com/studio#downloads" | grep -i mac.dmg | head -2 | grep -o -i -E "https.*" | cut -d '"' -f1)
    fi
    androidXML="https://dl.google.com/android/studio/patches/updates.xml"
    appNewVersion=$(curl -fsSL "$androidXML" | xmllint --xpath 'string((//channel[@status="release"]/build)[1]/@number)' - 2>/dev/null)
    expectedTeamID="EQHXZ8M8AV"
    blockingProcesses=( androidstudio )
    versionKey="CFBundleVersion"
    ;;
