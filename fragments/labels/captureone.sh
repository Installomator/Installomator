captureone|captureonepro)
    name="Capture One"
    type="dmg"
    captureoneSparkle=$(curl -fsL "https://www.captureone.com/update/capture-one-mac.xml")
    downloadURL=$(echo "${captureoneSparkle}" | xmllint --xpath "string(//item[1]/enclosure/@url)" - 2>/dev/null)
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*Mac\.([0-9.]+)\.dmg/\1/')
    expectedTeamID="5WTDB5F65L"
    ;;
