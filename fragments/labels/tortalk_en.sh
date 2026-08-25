tortalk_en)
    name="TorTalk EN"
    appName="TorTalk.app"
    type="pkg"
    downloadURL=$(curl -fsL "https://tortalk.se/student-or-pupil/?lang=en" | grep -o "https://.*.pkg")
    appNewVersion=$(echo "${downloadURL}" | grep -o "[0-9].*[0-9]"| awk -F "." '{print$1"."$2$3}')
    expectedTeamID="QUT3D5SU72"
    ;;
