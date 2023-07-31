shottr)
    name="Shottr"
    type="dmg"
    appNewVersion=$(curl -fs "https://shottr.cc/newversion.html" | xmllint --html --xpath 'substring-before(substring-after(string(//a[@id="downloadButton"]/small), "v"), ",")' - 2> /dev/null)
    downloadURL="https://shottr.cc/dl/Shottr-${appNewVersion}.dmg"
    expectedTeamID="2Y683PRQWN"
    ;;
