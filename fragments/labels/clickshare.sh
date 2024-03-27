clickshare)
    name="ClickShare"
    type="appInDmgInZip"
    downloadURL=$(curl -fs "https://www.barco.com/bin/barco/tde/downloadUrl.json?fileNumber=R3306192&tdeType=3" | grep -o '"downloadUrl":"https://[^"]*"' | cut -d'"' -f4)
    appNewVersion=$(curl -s "https://assets.cloud.barco.com/clickshare/release/RELEASES" | grep -Eo "ClickShare-[0-9]+\.[0-9]+\.[0-9]+-b[0-9]+" | sed 's/ClickShare-//' | head -1)
    expectedTeamID="P6CDJZR997"
    ;;
