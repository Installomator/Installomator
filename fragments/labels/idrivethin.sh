idrivethin)
    name="IDrive"
    type="pkgInDmg"
    pkgName="IDriveThin.pkg"
    downloadURL=$(curl -fs https://static.idriveonlinebackup.com/downloads/idrivethin/thin_version.js | sed 's/.*thinclient-mac\([^;]*\).*/\1/' | sed 's/.*\(https.*dmg\).*/\1/g')
    appNewVersion=$(curl -fs https://static.idriveonlinebackup.com/downloads/idrivethin/thin_version.js | sed 's/.*thin_mac_ver=\([^;]*\).*/\1/' | sed 's/.*Version \([0-9.]*\).*/\1/')
    versionKey="CFBundleVersion"
    expectedTeamID="JWDCNYZ922"
    ;;
