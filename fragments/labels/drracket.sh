drracket)
    name="DrRacket"
    type="dmg"
	appNewVersion=$(curl -fs https://racket-lang.org/download/ | grep -o 'racket-[0-9.]*-aarch64-macosx-cs\.dmg' | head -n 1 | sed 's/racket-\(.*\)-aarch64-macosx-cs\.dmg/\1/')
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL=$(echo "https://download.racket-lang.org/installers/${appNewVersion}/"$(curl -fs https://racket-lang.org/download/ | grep -o 'racket-[0-9.]*-aarch64-macosx-cs\.dmg' | head -n 1))
    else
        downloadURL=$(echo "https://download.racket-lang.org/installers/${appNewVersion}/"$(curl -fs https://racket-lang.org/download/ | grep -o 'racket-[0-9.]*-x86_64-macosx-cs\.dmg' | head -n 1))
    fi
    folderName="Racket v${appNewVersion}"
    appName="${folderName}/DrRacket.app"
    expectedTeamID="MHDH6AFHDR"
    ;;
    
