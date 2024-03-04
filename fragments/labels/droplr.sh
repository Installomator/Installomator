droplr)
    name="Droplr"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
     downloadURL="https://files.droplr.com/apps/mac-m1-current"
    elif [[ $(arch) == i386 ]]; then
     downloadURL="https://files.droplr.com/apps/mac-intel-current"
    fi
    appNewVersion="$(versionFromGit Droplr droplr-desktop-releases)"
    expectedTeamID="MZ25PHMY7Y"
    blockingProcesses=( "Droplr" "Droplr Helper (Plugin)" "Droplr Helper (GPU)" "Droplr Helper (Renderer)" "Droplr Helper" )
    ;;
