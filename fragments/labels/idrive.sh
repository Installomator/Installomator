idrive)
    name="IDrive"
    type="pkgInDmg"
    pkgName="IDrive.pkg"
    downloadURL=$(curl -fs https://static.idriveonlinebackup.com/downloads/version_mac.js | sed 's/.*href\([^;]*\).*/\1/' | sed 's/.*\(https.*dmg\).*/\1/g')
    appNewVersion=$(curl -fs https://static.idriveonlinebackup.com/downloads/version_mac.js | sed 's/.*mac_vernum=\([^;]*\).*/\1/' | sed 's/.*Version \([0-9.]*\).*/\1/')
    versionKey="CFBundleVersion"
    expectedTeamID="JWDCNYZ922"
    ;;
