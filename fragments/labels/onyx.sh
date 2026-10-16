onyx)
    name="OnyX"
    type="dmg"
    osVersion="${installedOSversion%%.*}"
    if [[ "$(arch)" == "i386" && "$osVersion" -ge 27 ]]; then
        printlog "OnyX for macOS ${osVersion} requires Apple Silicon (arm64)." ERROR
        cleanupAndExit 95 "OnyX requires Apple Silicon on macOS ${osVersion}" ERROR
    else
        downloadURL="https://www.titanium-software.fr/download/$osVersion/OnyX.dmg"
    fi
    appNewVersion=$(curl -fs https://www.titanium-software.fr/en/onyx.html | sed -nE "s/.*OnyX ([0-9]+([.][0-9]+)+) for macOS [A-Za-z ]+ ${osVersion}[^0-9].*/\\1/p" | head -1)
    expectedTeamID="T49MRBL8UL"
    ;;
