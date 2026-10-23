istatmenus)
    name="iStat Menus"
    type="zip"
    downloadURL="https://download.bjango.com/istatmenus/"
    expectedTeamID="Y93TK974AT"
    appNewVersion=$(curl -sL https://bjango.com/mac/istatmenus/ | grep -Eo 'iStat Menus [0-9]+(\.[0-9]+)+' | head -1 | grep -Eo '[0-9]+(\.[0-9]+)+')
    blockingProcesses=( "iStat Menus" "iStatMenusAgent" "iStat Menus Status" )
    ;;
