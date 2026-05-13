doctolib)
    name="Doctolib"
    type="dmg"
    versionKey="CFBundleVersion"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://ddv-install.doctolib.fr/DoctolibProDesktop-latest-arm64.dmg"
        appNewVersion=""
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://ddv-install.doctolib.fr/DoctolibProDesktop-latest.dmg"
    fi
    expectedTeamID="84K7XVJ72Q"
    ;;
