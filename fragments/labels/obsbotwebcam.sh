obsbotwebcam)
    name="OBSBOT_WebCam"
    type="dmg"
    downloadURL=$(curl -fsL "https://www.obsbot.com/download/obsbot-tiny-series" | xmllint --html --xpath 'string(//a[contains(@href,"WebCam_OA_E_MacOS")]/@href)' - 2> /dev/null)
    appNewVersion=$(curl -fsL "https://www.obsbot.com/download/obsbot-tiny-series" | xmllint --html --xpath 'substring-after(substring-before(string(//a[contains(@href,"WebCam_OA_E_MacOS")]/@href),"_release"),"MacOS_")' - 2> /dev/null)
    expectedTeamID="7GJANK3822"
    ;;
