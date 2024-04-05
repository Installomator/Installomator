mendeleyreferencemanager)
    name="Mendeley Reference Manager"
    type="dmg"
    downloadURL=$(curl -fs "https://www.mendeley.com/download-reference-manager/macOS" | grep -oE "https://static.mendeley.com/bin/desktop/.*?.dmg")
    appNewVersion=$(curl -fs "https://www.mendeley.com/download-reference-manager/macOS" | grep -oE "https://static.mendeley.com/bin/desktop/.*?.dmg" | sed -n 's/.*mendeley-reference-manager-\([0-9.-]*\)-x64.dmg/\1/p')
    expectedTeamID="45K89Y5X9B"
    #Company="Elsevier Inc."
    ;;
