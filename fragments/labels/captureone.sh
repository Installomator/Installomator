captureone|captureonepro)
    name="Capture One"
    type="dmg"
    appName="Capture One.app"
    blockingProcesses=("Capture One")
    expectedTeamID="5WTDB5F65L"
    downloadURL=$(curl -fsL "https://www.captureone.com/en/account/download/trial-confirmation?intent=trial-pro" | grep -Eo 'https://downloads\.captureone\.pro/d/mac/[A-Za-z0-9]+/CaptureOne\.Mac\.[0-9\.]+\.dmg' | head -1)
    appNewVersion=$(echo "$downloadURL" | sed -n 's/.*CaptureOne\.Mac\.\([0-9.]*\)\.dmg.*/\1/p')
    ;;
