dia)
    name="Dia"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://releases.diabrowser.com/release/Dia-latest.dmg"
    else
        printlog "Dia is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "Dia requires Apple Silicon" ERROR
    fi
    appNewVersion=$(curl -sIL "$downloadURL" | sed -nE 's/.*Dia-([0-9]+([.][0-9]+)+)-[0-9]+[.]dmg.*/\1/p')
    blockingProcesses=( "Dia" )
    expectedTeamID="S6N382Y83G"
    ;;
