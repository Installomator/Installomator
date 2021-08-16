devonthink)
    # It's a zipped dmg file, needs function installAppInDmgInZip
    # credit: Søren Theilgaard (@theilgaard)
    name="DEVONthink 3"
    type="appInDmgInZip"
    downloadURL=$( curl -fs https://www.devontechnologies.com/apps/devonthink | grep -i "download.devon" | tr '"' '\n' | tr "'" '\n' | grep -e '^https://' )
    appNewVersion=$( echo ${downloadURL} | tr '/' '\n' | grep "[0-9]" | grep "[.]" | head -1 )
    expectedTeamID="679S2QUWR8"
    ;;
