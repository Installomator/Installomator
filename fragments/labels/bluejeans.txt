bluejeans)
    name="BlueJeans"
    type="pkg"
    downloadURL=$(curl -fs "https://www.bluejeans.com/downloads" | xmllint --html --format - 2>/dev/null | grep -o "https://.*BlueJeansInstaller.dmg" | sed 's/dmg/pkg/g')
    appNewVersion=$(echo $downloadURL | cut -d '/' -f6)
    expectedTeamID="HE4P42JBGN"
    #Company="Verizon"
    ;;
