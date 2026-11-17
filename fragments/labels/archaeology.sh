archaeology)
    name="Archaeology"
    type="dmg"
    downloadURL="https://www.mothersruin.com/software/downloads/Archaeology.dmg"
    appNewVersion=$(curl -fs https://mothersruin.com/software/Archaeology/data/ArchaeologyVersionInfo.plist | grep -A1 CFBundleShortVersionString | tail -1 | sed -E 's/.*>([0-9.]*)<.*/\1/g')
    expectedTeamID="936EB786NH"
    ;;
