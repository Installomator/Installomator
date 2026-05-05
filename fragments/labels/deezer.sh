deezer)
    name="Deezer"
    type="dmg"
    downloadURL="https://www.deezer.com/desktop/download?platform=darwin&architecture=x64&platformVersion=9999"
    appNewVersion=$(curl -fsLI "$downloadURL" | grep -o "DeezerDesktop_[0-9]*\.[0-9]*\.[0-9]*" | cut -d'_' -f2)
    expectedTeamID="7QLUP2K45C"
    ;;
