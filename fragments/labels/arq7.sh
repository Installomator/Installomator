arq7)
    name="Arq"
    type="pkg"
    packageID="com.haystacksoftware.Arq"
    downloadURL="https://www.arqbackup.com/download/arqbackup/Arq7.pkg"
    appNewVersion=$(curl -fsSL "https://www.arqbackup.com/download/arqbackup/arq7_release_notes.html" | sed -nE 's|<h1>Release Notes for Arq Backup Version ([0-9]+(\.[0-9]+)+)</h1>|\1|p' | head -n 1)
    expectedTeamID="48ZCSDVL96"
    blockingProcesses=( "Arq" "ArqAgent" "ArqMonitor" )
    ;;
