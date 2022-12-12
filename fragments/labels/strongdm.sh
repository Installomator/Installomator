strongdm)
    name="strongDM"
    type="dmg"
    downloadURL="https://app.strongdm.com/downloads/client/darwin"
    appNewVersion=$(curl -fsLIXGET "https://app.strongdm.com/downloads/client/darwin" | grep -i "^content-disposition" | sed -e 's/.*filename\=\"SDM\-\(.*\)\.dmg\".*/\1/')
    appName="SDM.app"
    blockingProcesses=( "SDM" )
    expectedTeamID="W5HSYBBJGA"
    ;;
