hudlsportscode)
    name="Hudl Sportscode"
    type="appInDmgInZip"
    appNewVersion=$(curl -fs https://www.hudl.com/downloads/elite | grep -A 1 "Download Hudl Sportscode" | grep -o -e "[0-9.]*")
    downloadURL="https://sportscode64-updates.s3.amazonaws.com/PublicReleaseDmgs/HudlSportscode-$appNewVersion.dmg.zip"
	versionKey="CFBundleVersion"
    expectedTeamID="4M6T2C723P"
    ;;
