topazvideo|\
topazvideoai)
    name="Topaz Video AI"
    type="dmg"
    downloadURL="https://topazlabs.com/d/tvai/latest/mac/full"
    archiveName=$(curl -fsIL $downloadURL | grep -i ^location | awk -F "/" '{print $NF}' | tr -d '\r\n')
    appNewVersion=$(grep -oi "[0-9].*[0-9]" <<< $archiveName)
    expectedTeamID="3G3JE37ZHF"
    ;;
