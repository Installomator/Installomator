keyshotstudio)
    name="KeyShot Studio"
    type="pkg"
    expectedTeamID="W7B24M74T3"
    downloadURL="https://download.keyshot.com/keyshot2025/keyshot_studio_mac64_2025.2_14.1.1.5.pkg"
    appNewVersion=$( echo "$downloadURL" | cut -d '_' -f 5 | rev | cut -d '.' -f2- | rev )
    appCustomVersion() {
        customVersionFile="/Users/Shared/.KeyShotStudioInstalledVersion"
        if [ -f "${customVersionFile}" ]; then
            result=$(cat "${customVersionFile}")
        elif [ -d "/Applications/KeyShot Studio.app/Contents/" ]; then
            result=$(/usr/bin/defaults read "/Applications/KeyShot Studio.app/Contents/Info.plist" CFBundleVersion)
        fi
        echo $appNewVersion > "${customVersionFile}"
        echo $result
    }
    ;;
