doctolib)
    name="Doctolib"
    type="dmg"
    versionKey="CFBundleVersion"
    if [[ $(arch) == "arm64" ]]; then
    	downloadURL="$(curl -fs https://info.doctolib.de/desktop/ | sed -n '/macOS/,$p' | grep -o '"title":"Mac","url":"[^"]*' | sed -E 's/.*"url":"(.*)/\1/' | sed 's/\\//g' | sed -n '1p')"
    	appNewVersion=""
    elif [[ $(arch) == "i386" ]]; then
    	downloadURL="$(curl -fs https://info.doctolib.de/desktop/ | sed -n '/macOS/,$p' | grep -o '"title":"Mac","url":"[^"]*' | sed -E 's/.*"url":"(.*)/\1/' | sed 's/\\//g' | sed -n '2p')"
    	appNewVersion=""
    fi
    expectedTeamID="84K7XVJ72Q"
    # blockingProcesses=( Doctolib )
    ;;
