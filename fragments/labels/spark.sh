spark)
    name="Spark"
    type="dmg"
    downloadURL="$(curl -fsL https://sparkmailapp.com/download | grep -m 1 -o "https.*dmg")"
    versionKey="CFBundleVersion"
    appNewVersion="$(echo $downloadURL | awk -F'/' '{ print $(NF-1) }')"
    appName="Spark Desktop.app"
    expectedTeamID="3L68KQB4HG"
    ;;
