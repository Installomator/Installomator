audiopen)
    name="AudioPen"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(downloadURLFromGit louispereira23 AudioPen-Releases)
        appNewVersion=$(versionFromGit louispereira23 AudioPen-Releases)
    else
        printlog "AudioPen is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "AudioPen requires Apple Silicon" ERROR
    fi
    expectedTeamID="WBFQ68C53U"
    ;;
