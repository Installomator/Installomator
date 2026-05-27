gimp)
    name="GIMP"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=https://$(curl -fs https://www.gimp.org/downloads/ | grep -m 1 -o "download.*gimp-.*-arm64.dmg")
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=https://$(curl -fs https://www.gimp.org/downloads/ | grep -m 1 -o "download.*gimp-.*-x86_64.dmg")
    fi
    appNewVersion=$(echo $downloadURL | cut -d "-" -f 2)
    expectedTeamID="T25BQ8HSJF"
    ;;
