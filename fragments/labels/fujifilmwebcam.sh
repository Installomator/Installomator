fujifilmwebcam)
    name="FUJIFILM X Webcam 2"
    type="pkg"
    downloadURL=$(curl -fsL "https://www.fujifilm-x.com/en-us/support/download/software/x-webcam/" | grep "https.*pkg" | sed -E 's/.*(https:\/\/dl.fujifilm-x\.com\/support\/software\/.*\.pkg[^\<]).*/\1/g' | sed -e 's/^"//' -e 's/"$//')
    appNewVersion=$( echo “${downloadURL}” | sed -E 's/.*XWebcamIns([0-9]*).*/\1/g' | sed -E 's/([0-9])([0-9]).*/\1\.\2/g')
    expectedTeamID="34LRP8AV2M"
    ;;
