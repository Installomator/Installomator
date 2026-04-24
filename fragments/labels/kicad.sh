kicad)
    name="KiCad"
    type="dmg"
    archiveName="kicad-unified-universal-"
    downloadURL="$(downloadURLFromGit KiCad kicad-source-mirror)"
    appNewVersion="$(versionFromGit KiCad kicad-source-mirror)"
    folderName="KiCad"
    appName="${folderName}/KiCad.app"
    versionKey="CFBundleShortVersionString"
    expectedTeamID="9FQDHNY6U2"
    blockingProcesses=("gerbview" "bitmap2component" "kicad" "pl_editor" "pcb_calculator" "pcbnew" "eeschema")
    ;;
