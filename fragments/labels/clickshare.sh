clickshare)
    name="ClickShare"
    type="appInDmgInZip"
    downloadURL=$(curl -fs "https://www.barco.com/bin/barco/tde/downloadUrl.json?fileNumber=R3306192&tdeType=3" | grep -o 'https://[^"]*')
    appNewVersion=$(curl -fs "https://www.barco.com/content/dxp/regions-countries/global/en/support/software/R3306192/jcr:content/root/main_section/supportdownloadversi.asynccomponent.html"| xmllint --html -xpath "substring-after(string(//dd[starts-with(text(), 'v')]),'v')" - 2> /dev/null)
    expectedTeamID="P6CDJZR997"
    ;;