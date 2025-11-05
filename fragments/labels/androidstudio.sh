androidstudio)
    name="Android Studio"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        downloadURL=$(curl -fsL "https://developer.android.com/studio#downloads" | grep -i arm.dmg | head -2 | grep -o -i -E "https.*" | cut -d '"' -f1)
        appNewVersion=$( echo "${downloadURL}" | head -1 | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\).*$/\1/' )
    elif [[ $(arch) == i386 ]]; then
        downloadURL=$(curl -fsL "https://developer.android.com/studio#downloads" | grep -i mac.dmg | head -2 | grep -o -i -E "https.*" | cut -d '"' -f1)
        appNewVersion=$( echo "${downloadURL}" | head -1 | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\).*$/\1/' )
    fi
    expectedTeamID="EQHXZ8M8AV"
    blockingProcesses=( androidstudio )

    appCustomVersion() {
        customVersionFile="/Users/Shared/.AndroidStudioInstalledVersion"
        if [ -f "${customVersionFile}" ]; then
            result=$(cat "${customVersionFile}")
        fi
        echo $appNewVersion > "${customVersionFile}"
        echo $result
    }
    ;;
