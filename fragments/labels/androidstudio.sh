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
        # Android Studio only contains the Major.minor in the Info.plist
        # We're going to use a hidden file to store the full Major.minor.minor.minor version number
        customVersionFile="/Users/Shared/.AndroidStudioInstalledVersion"

        # Check it the hidden custom version file exists. If so, use that version number.
        if [ -f "${customVersionFile}" ]; then
            result=$(cat "${customVersionFile}")
        fi

        # Write the appNewVersion value to the custom version file.
        # This assumes any run of this label executed successfully and the installed version was updated to the
        #   latest version because Installomator doesn't provide that kind of feedback to the label fragment code.
        #   This is a hack, but it solves the problem of the software being re-installed on every run because the
        #   installed version doesn't accurately report it's full version.
        echo $appNewVersion > "${customVersionFile}"

        # Write out whichever installed version number we found into appCustomVersion
        echo $result
    }
    ;;
