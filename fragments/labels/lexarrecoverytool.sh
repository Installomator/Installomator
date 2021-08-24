lexarrecoverytool)
    # credit: Søren Theilgaard (@theilgaard)
    name="Lexar Recovery Tool"
    type="appInDmgInZip"
    downloadURL="https://www.lexar.com$( curl -fs "https://www.lexar.com/support/downloads/" | grep -i "mac" | grep -i "recovery" | head -1 | tr '"' '\n' | grep -i ".zip" )"
    #appNewVersion=""
    expectedTeamID="Y8HM6WR2DV"
    ;;
