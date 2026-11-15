doctolib)
    name="Doctolib"
    type="dmg"
    versionKey="CFBundleVersion"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://ddv-install.doctolib.fr/DoctolibProDesktop-latest-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://ddv-install.doctolib.fr/DoctolibProDesktop-latest.dmg"
    fi
    appNewVersion=$(curl -fsL "https://luti.tranquil.it/history/tis-doctolib-client" | grep -o -E 'tis-doctolib-client/mac[A-Za-z0-9/_-]*[[:space:]]*:[[:space:]]*[0-9]+\.[0-9]+\.[0-9]+' | head -1 | grep -o -E '[0-9]+\.[0-9]+\.[0-9]+$')
    expectedTeamID="84K7XVJ72Q"
    ;;
