webexvdiplugin)
    name="Cisco Webex VDI Plugin"
    type="pkg"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL=$(curl -fsSL https://help.webex.com/en-us/article/ntp1us7/Webex-App-%7C-VDI-release-notes#reference-template_e92f9ad6-4f8c-4f69-b967-8615da1788ad 2>/dev/null | awk -F 'href="' '/<td align="" headers="">MacOS \(Apple Silicon\)/ {split($2, a, "\""); print a[1]; exit}')
    else
        downloadURL=$(curl -fsSl https://help.webex.com/en-us/article/ntp1us7/Webex-App-%7C-VDI-release-notes#reference-template_e92f9ad6-4f8c-4f69-b967-8615da1788ad 2>/dev/null | awk -F 'href="' '/<td align="" headers="">MacOS \(Intel base\)/ {split($2, a, "\""); print a[1]; exit}')
    fi
    expectedTeamID="DE8Y96K9QP"
    appNewVersion=$(curl -fsSL https://help.webex.com/en-us/article/ntp1us7/Webex-App-%7C-VDI-release-notes#reference-template_e92f9ad6-4f8c-4f69-b967-8615da1788ad 2>/dev/null | awk '/<th align="" font-weight="bold" id="">Webex App VDI Plugin/ {gsub(/.*\(/, "", $0); gsub(/\).*/, "", $0); print; exit}')
    ;;
