doctolib)
    name="Doctolib"
    type="dmg"
    downloadURL="$(curl -fs https://info.doctolib.de/desktop/ | grep -o '"title":"Mac","url":"[^"]*' | sed -E 's/.*"url":"(.*)/\1/' | sed 's/\\//g')"
    appNewVersion="$(curl -sf "https://luti.tranquil.it/listfolder/2c4c5f8a-a556-41ba-b2af-903697c0f974" | grep -A5 "tis-doctolib-client/macos/arm" | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)"
    expectedTeamID="84K7XVJ72Q"
    # blockingProcesses=( Doctolib )
    ;;
