droplr)
    name="Droplr"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
     downloadURL="https://files.droplr.com/apps/mac-m1-current"
     appNewVersion=$(curl -fsLIXGET "https://files.droplr.com/apps/mac-m1-current" | grep -i "^content-disposition" | sed -e 's/.*filename\=Droplr\-\(.*\)\-arm64\.dmg.*/\1/')
    elif [[ $(arch) == i386 ]]; then
     downloadURL="https://files.droplr.com/apps/mac-intel-current"
     appNewVersion=$(curl -fsLIXGET "https://files.droplr.com/apps/mac-intel-current" | grep -i "^content-disposition" | sed -e 's/.*filename\=Droplr\-\(.*\)\.dmg.*/\1/')
    fi
    expectedTeamID="MZ25PHMY7Y"
    blockingProcesses=( "Droplr" "Droplr Helper (Plugin)" "Droplr Helper (GPU)" "Droplr Helper (Renderer)" "Droplr Helper" )
    ;;
