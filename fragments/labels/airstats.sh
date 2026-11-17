airstats)
    name="AirStats"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="$(downloadURLFromGit byrencheema airstats)"
    else
        printlog "AirStats is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "AirStats requires Apple Silicon" ERROR
    fi
    appNewVersion="$(versionFromGit byrencheema airstats)"
    expectedTeamID="L77LA4GLFN"
    ;;
