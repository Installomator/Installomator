idrive)
    name="IDrive"
    type="pkgInDmg"
    pkgName="IDrive.pkg"
    downloadURL=$(curl -fs https://static.idriveonlinebackup.com/downloads/version_mac.js | tr -d '\n\t' | sed -E 's/.*(https.*dmg).*/\1/g')
    appNewVersion=$(curl -fs https://static.idriveonlinebackup.com/downloads/version_mac.js | tr -d '\n\t' | sed -E 's/.*mac_vernum\=\"Version\ ([0-9.]*).*/\1/g')
    versionKey="CFBundleVersion"
    expectedTeamID="JWDCNYZ922"
    blockingProcesses=( NONE )
    ;;
