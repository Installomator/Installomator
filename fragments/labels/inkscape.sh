inkscape)
    name="Inkscape"
    type="dmg"
    appCustomVersion() { /Applications/Inkscape.app/Contents/MacOS/inkscape --version | cut -d " " -f2 }
    inkscapeReleasesJSON=$(curl -fsL -A "Installomator/$VERSION (+https://github.com/Installomator/Installomator)" "https://media.inkscape.org/media/releases.json")
    if ! getJSONValue "$inkscapeReleasesJSON" '' >/dev/null 2>&1; then
        cleanupAndExit 2 "Inkscape: could not fetch or parse releases JSON" ERROR
    fi
    appNewVersion=$(getJSONValue "$inkscapeReleasesJSON" '[0].releases[0].version')
    if [[ -z "$appNewVersion" ]]; then
        cleanupAndExit 2 "Inkscape: could not determine version from releases JSON" ERROR
    fi
    if [[ $(arch) == arm64 ]]; then
        inkscapePlatform="macOS : dmg (arm64)"
    elif [[ $(arch) == i386 ]]; then
        inkscapePlatform="macOS : dmg (Intel)"
    else
        cleanupAndExit 99 "Inkscape: unsupported architecture $(arch)" ERROR
    fi
    downloadURL=$(getJSONValue "$inkscapeReleasesJSON" "[0].releases[0].platforms.find(platform => platform.name === \"${inkscapePlatform}\").download")
    if [[ -z "$downloadURL" ]]; then
        cleanupAndExit 2 "Inkscape: could not determine download URL from releases JSON" ERROR
    fi
    expectedTeamID="SW3D6BB6A6"
    ;;
