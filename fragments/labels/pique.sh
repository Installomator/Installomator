pique)
    name="Pique"
    type="pkg"
    if ! is-at-least 26 "$installedOSversion"; then
        printlog "Pique requires macOS 26 or later." ERROR
        cleanupAndExit 15 "Pique requires macOS 26 or later" ERROR
    fi
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(downloadURLFromGit macadmins pique)
    else
        printlog "Pique is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "Pique requires Apple Silicon" ERROR
    fi
    appNewVersion=$(printf '%s\n' "$downloadURL" | sed -nE 's#.*/releases/download/v?([^/]+)/.*#\1#p')
    expectedTeamID="T4SK8ZXCXG"
    ;;
