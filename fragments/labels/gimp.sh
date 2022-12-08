gimp)
    name="GIMP"
    type="dmg"
    downloadURL=https://$(curl -fs https://www.gimp.org/downloads/ | grep -m 1 -o "download.*gimp-.*.dmg")
    appNewVersion=$(echo $downloadURL | cut -d "-" -f 2)
    expectedTeamID="T25BQ8HSJF"
    ;;
