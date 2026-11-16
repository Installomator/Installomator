doctolib)
    name="Doctolib"
    type="dmg"
    doctolibFeed=$(curl -fsL "https://ddv-install.doctolib.fr/latest/latest-mac.yml")
    if [[ $(arch) == "arm64" ]]; then
        doctolibArch="arm64"
    elif [[ $(arch) == "i386" ]]; then
        doctolibArch="x64"
    fi
    downloadURL="https://ddv-install.doctolib.fr/latest/$(echo "$doctolibFeed" | grep -oE "DoctolibProDesktop-[0-9.]+-mac-${doctolibArch}\.dmg" | head -1)"
    appNewVersion=$(echo "$doctolibFeed" | awk '/^version:/ {print $2}')
    expectedTeamID="84K7XVJ72Q"
    ;;
