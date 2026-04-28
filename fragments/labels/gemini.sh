gemini)
    name="Gemini"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://dl.google.com/release2/j33ro/release/Gemini.dmg"
    else
        printlog "Gemini is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "Gemini requires Apple Silicon" ERROR
    fi
    expectedTeamID="EQHXZ8M8AV"
    ;;
