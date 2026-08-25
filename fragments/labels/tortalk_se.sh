tortalk_se)
    name="TorTal SE"
    appName="TorTalk.app"
    type="pkg"
    downloadURL=$(curl -fsL https://tortalk.se/student-elev/ | grep -o "https://.*.pkg")
    appNewVersion=$(echo "${downloadURL}" | grep -o "[0-9].*[0-9]"| awk -F "." '{print$1"."$2$3}')
    expectedTeamID="QUT3D5SU72"
    ;;
