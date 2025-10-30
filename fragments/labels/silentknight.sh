silentknight)
    # SilentKnight automatic checking of security systems
    name="SilentKnight"
    type="zip"
    folderName="$(curl -fs https://eclecticlight.co/downloads/ | grep -o 'silentknight[0-9]*\.zip' | sort -V | tail -n 1 | sed -E 's/silentknight([0-9]+)\.zip/silentknight\1/')"
    appName="${folderName}/SilentKnight.app"
    downloadURL="$(curl -fs https://eclecticlight.co/downloads/ | grep -o 'href="[^"]*silentknight[0-9]*\.zip"' | sed 's/href="//;s/"//' | sort -V | tail -n 1)"
    appNewVersion="$(curl -fs https://eclecticlight.co/downloads/ | grep -o 'SilentKnight [0-9]\+\(\.[0-9]\+\)\? (' | sed -E 's/SilentKnight ([0-9]+(\.[0-9]+)?).*/\1/' | sort -V | tail -n 1)"
    expectedTeamID="QWY4LRW926"
    ;;
