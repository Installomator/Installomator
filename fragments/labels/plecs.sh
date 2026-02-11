plecs)
    name="Plecs 5.0"
    type="dmg"
    appNewVersion=$( curl -fs https://www.plexim.com/download/standalone | grep "_maca64.dmg</a>" | awk -F'standalone-|_maca64.dmg' '{print $2}'| head -1|sed -e 's/-/\./g' -e 's/[^0-9\.]//g' )
    blockingProcesses=( "PLECS" "PLECS 5.0" )
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://www.plexim.com/sites/default/files/packages/plecs-standalone-$( echo $appNewVersion | sed 's/\./-/g' )_maca64.dmg"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://www.plexim.com/sites/default/files/packages/plecs-standalone-$( echo $appNewVersion | sed 's/\./-/g' )_maci64.dmg"
    fi
    expectedTeamID="65S8P623ZX"
    ;;
