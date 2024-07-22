gimp)
    name="GIMP"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=https://$(curl -fs https://www.gimp.org/downloads/ | grep -m 1 -o 'download\.gimp\.org\/gimp\/v[0-9\.]*\/macos\/gimp-[0-9\.]*-arm64.*\.dmg\"' | tr -d '"')
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=https://$(curl -fs https://www.gimp.org/downloads/ | grep -m 1 -o 'download\.gimp\.org\/gimp\/v[0-9\.]*\/macos\/gimp-[0-9\.]*-x86_64.*\.dmg\"' | tr -d '"')
    fi
    appNewVersion=$(echo $downloadURL | cut -d "-" -f 2)
    expectedTeamID="T25BQ8HSJF"
    ;;
