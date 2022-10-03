inetclearreportsdesigner)
    name="i-Net Clear Reports Designer"
    type="appindmg"
    appNewVersion=$(curl -s https://www.inetsoftware.de/products/clear-reports/designer | grep "Latest release:" | cut -d ">" -f 4 | cut -d \  -f 2)
    downloadURL=$(curl -s https://www.inetsoftware.de/products/clear-reports/designer | grep $appNewVersion | grep dmg | cut -d ">" -f 12 | cut -d \" -f 2)
    expectedTeamID="9S2Y97K3D9"
    blockingProcesses=( "clear-reports-designer" )
    #forcefulQuit=YES
    ;;
