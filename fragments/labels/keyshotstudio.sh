keyshotstudio)
    name="KeyShot Studio"
    type="pkg"
    expectedTeamID="W7B24M74T3"
    downloadURL="https://www.keyshot.com/download/370762/"
    appNewVersion="$( curl -v "$downloadURL" 2>&1 | grep location | cut -d '_' -f 5 | rev | cut -d '.' -f2- | rev )"
    appCustomVersion() {
        if [ -d "/Applications/KeyShot Studio.app/Contents/" ]; then
            /usr/bin/defaults read "/Applications/KeyShot Studio.app/Contents/Info.plist" CFBundleVersion
        fi
    }
    ;;
