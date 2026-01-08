topazgigapixel|\
topazgigapixelai)
    # credit: Tully Jagoe
    name="Topaz Gigapixel AI"
    type="pkg"
    versionKey="CFBundleShortVersionString"
    downloadURL="https://topazlabs.com/d/gigapixel/latest/mac/full"
    archiveName=$(curl -fsIL $downloadURL | grep -i ^location | awk -F "/" '{print $NF}')
    appNewVersion=$(grep -oi "[0-9].*[0-9]" <<< $archiveName)
    expectedTeamID="3G3JE37ZHF"
    ;;
