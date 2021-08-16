favro)
    name="Favro"
    type="dmg"
    downloadURL="https://download.favro.com/FavroDesktop/macOS/x64/$(curl -fs https://download.favro.com/FavroDesktop/macOS/x64/Latest.html | cut -d ">" -f1 | cut -d "=" -f 4 | cut -d '"' -f1)"
    appNewVersion="$(curl -fs https://download.favro.com/FavroDesktop/macOS/x64/Latest.html | cut -d ">" -f1 | cut -d "=" -f 4 | cut -d '"' -f1 | sed -E 's/.*-([0-9.]*)\.dmg/\1/g')"
    expectedTeamID="PUA8Q354ZF"
    ;;
