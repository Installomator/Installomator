idrivethin)
    name="IDrive"
    type="pkgInDmg"
    pkgName="IDriveThin.pkg"
    downloadURL=$(curl -fs https://static.idriveonlinebackup.com/downloads/idrivethin/thin_version.js | tr -d '\n\t' | sed -E 's/.*thinclient-mac([^;]*).*/\1/g' | sed -E 's/.*(https.*dmg).*/\1/g')
    appNewVersion=$(curl -fs https://static.idriveonlinebackup.com/downloads/idrivethin/thin_version.js | tr -d '\n\t' | sed -E 's/.*thin\_mac\_ver\=\"Version\ ([0-9.]*).*/\1/g')
    versionKey="CFBundleVersion"
    expectedTeamID="JWDCNYZ922"
    blockingProcesses=( NONE )
    ;;
