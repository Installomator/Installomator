clickshare)
    # credit: Søren Theilgaard (@theilgaard)
    name="ClickShare"
    type="appInDmgInZip"
    downloadURL=https://www.barco.com$(curl -fs "https://www.barco.com/en/clickshare/app" | grep -E -o '(\/\S*Download\?FileNumber=R3306192\S*ShowDownloadPage=False)' | tail -1)
    expectedTeamID="P6CDJZR997"
    ;;
