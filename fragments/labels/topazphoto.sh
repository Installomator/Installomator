topazphoto|\
topazphotoai)
    name="Topaz Photo AI"
    type="pkg"
    downloadURL="https://topazlabs.com/d/photo/latest/mac/full"
    archiveName=$(curl -fsIL $downloadURL | grep -i ^location | awk -F "/" '{print $NF}' | tr -d '\r\n')
    appNewVersion=$(grep -oi "[0-9].*[0-9]" <<< $archiveName)
    expectedTeamID="3G3JE37ZHF"
    ;;
