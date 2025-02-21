suspiciouspackage)
    name="Suspicious Package"
    type="dmg"
    downloadURL="https://mothersruin.com/software/downloads/SuspiciousPackage.dmg"
    appNewVersion=$(curl -fs "https://www.mothersruin.com/software/SuspiciousPackage/data/SuspiciousPackageVersionInfo.plist" | grep -A1 CFBundleShortVersionString | tail -1 | sed -E 's/.*>([0-9.]*)<.*/\1/g')
    expectedTeamID="936EB786NH"
    ;;
