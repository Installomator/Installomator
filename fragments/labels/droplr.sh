droplr)
    name="Droplr"
    type="dmg"
    downloadURL="$(downloadURLFromGit Droplr droplr-desktop-releases)"
    appNewVersion="$(versionFromGit Droplr droplr-desktop-releases)"
    expectedTeamID="MZ25PHMY7Y"
    blockingProcesses=( "Droplr" "Droplr Helper (Plugin)" "Droplr Helper (GPU)" "Droplr Helper (Renderer)" "Droplr Helper" )
    ;;
