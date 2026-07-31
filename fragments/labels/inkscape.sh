inkscape)
    name="Inkscape"
    type="dmg"
    appCustomVersion() { /Applications/Inkscape.app/Contents/MacOS/inkscape --version | cut -d " " -f2 }
    inkscapeReleasesJSON=$(curl -fsL -A "Installomator/$VERSION (+https://github.com/Installomator/Installomator)" "https://media.inkscape.org/media/releases.json")
    if ! printf '%s' "$inkscapeReleasesJSON" | jq -e . > /dev/null 2>&1; then
        cleanupAndExit 2 "Inkscape: could not fetch or parse releases JSON" ERROR
    fi
    appNewVersion=$(jq -r '.[0].releases | map(select(.released != null)) | max_by(.released) | .version' <<< "$inkscapeReleasesJSON")
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
    downloadURL=$(printf '%s' "$inkscapeReleasesJSON" | jq -r --arg version "$appNewVersion" --arg platform "$inkscapePlatform" 'first(.[0].releases[] | select(.version == $version) | .platforms[] | select(.name == $platform) | .download) // empty')
    if [[ -z "$downloadURL" ]]; then
        cleanupAndExit 2 "Inkscape: could not determine download URL from releases JSON" ERROR
    fi
    expectedTeamID="SW3D6BB6A6"
    ;;
