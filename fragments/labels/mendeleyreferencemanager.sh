mendeleyreferencemanager)
    name="Mendeley Reference Manager"
    type="dmg"
    downloadURL=$(curl -fs "https://www.mendeley.com/download-reference-manager/macOS" | grep -E -o "https://static.mendeley.com/bin/desktop/.*?.dmg")
    appNewVersion=$(curl -fs "https://www.mendeley.com/download-reference-manager/macOS" | grep -E -o "https://static.mendeley.com/bin/desktop/.*?.dmg" | awk -F'mendeley-reference-manager-' '{print $2}' | sed 's/.dmg//g')
    expectedTeamID="45K89Y5X9B"
    #Company="Elsevier Inc."
    ;;
