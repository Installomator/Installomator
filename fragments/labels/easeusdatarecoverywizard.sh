easeusdatarecoverywizard)
    # credit: Søren Theilgaard (@theilgaard)
    name="EaseUS Data Recovery Wizard"
    type="dmg"
    downloadURL=$( curl -fsIL https://down.easeus.com/product/mac_drw_free_setup | grep -i "^location" | awk '{print $2}' | tr -d '\r\n' )
    #appNewVersion=""
    expectedTeamID="DLLVW95FSM"
    ;;
