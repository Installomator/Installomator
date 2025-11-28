keyshotstudio)
    name="KeyShot Studio"
    type="pkg"
    expectedTeamID="W7B24M74T3"
    downloadURL="https://download.keyshot.com/keyshot2025/keyshot_studio_mac64_2025.2_14.1.1.5.pkg"
    appNewVersion=$( echo "$downloadURL" | cut -d '_' -f 5 | rev | cut -d '.' -f2- | rev )
    appCustomVersion() {
        # KeyShot Studio only contains the Major.minor.minor in the Info.plist
        # We're going to use a hidden file to store the full Major.minor.minor.minor version number
        customVersionFile="/Users/Shared/.KeyShotStudioInstalledVersion"

        # Check it the hidden custom version file exists. If so, use that version number.
        if [ -f "${customVersionFile}" ]; then
            result=$(cat "${customVersionFile}")
        elif [ -d "/Applications/KeyShot Studio.app/Contents/" ]; then
            # Custom version file doesn't exist - use the Major.minor.minor found in the app's Info.plist
            result=$(/usr/bin/defaults read "/Applications/KeyShot Studio.app/Contents/Info.plist" CFBundleVersion)
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
