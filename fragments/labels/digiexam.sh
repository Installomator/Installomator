digiexam)
    name="Digiexam"
    type="tbz"
    archiveName="Digiexam.app.tar.gz"
    crabNebulaData=$(curl -fsL "https://cdn.crabnebula.app/update/digiexam/digiexam/macos-universal/0.0.0")
    appNewVersion=$(printf "%s" "$crabNebulaData" | plutil -extract version raw -o - -)
    downloadURL=$(printf "%s" "$crabNebulaData" | plutil -extract url raw -o - -)
    expectedTeamID="73T9H7VE4P"
    blockingProcesses=( "digiexam" )
    ;;
