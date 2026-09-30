antconc)
    name="AntConc"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        antConcPage=$(curl -fsL "https://www.laurenceanthony.net/software/antconc/")
        downloadURL="https://www.laurenceanthony.net/$(echo "$antConcPage" | grep -oE 'software/antconc/releases/AntConc[0-9]+/macos/silicon/AntConc-[0-9.]+-macos-apple-silicon\.dmg' | head -n 1)"
        appNewVersion=$(echo "$downloadURL" | sed -E 's|.*/AntConc-([0-9]+(\.[0-9]+)+)-macos-apple-silicon\.dmg|\1|')
    else
        printlog "AntConc is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "AntConc requires Apple Silicon" ERROR
    fi
    expectedTeamID="28C42U4N5U"
    ;;
    
