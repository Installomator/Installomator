ulbow)
    # Ulbow log browser designed for ease of use without sacrificing power
    name="Ulbow"
    type="zip"
    folderName="$(curl -fs https://eclecticlight.co/downloads/ | grep -o 'ulbow[0-9]*\.zip' | sort -V | tail -n 1 | sed -E 's/ulbow([0-9]+)\.zip/ulbow\1/')"
    appName="${folderName}/Ulbow.app"
    downloadURL="$(curl -fs https://eclecticlight.co/downloads/ | grep -o 'href="[^"]*ulbow[0-9]*\.zip"' | sed 's/href="//;s/"//' | sort -V | tail -n 1)"
    appNewVersion="$(curl -fs https://eclecticlight.co/downloads/ | grep -o 'Ulbow [0-9]\+\(\.[0-9]\+\)\? (' | sed -E 's/Ulbow ([0-9]+(\.[0-9]+)?).*/\1/' | sort -V | tail -n 1)"
    expectedTeamID="QWY4LRW926"
    ;;
