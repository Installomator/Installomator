onscreencontrol)
    name="OnScreen Control"
    type="pkgInZip"
    packageID="com.LGSI.OnScreen-Control"
    downloadFile=$(curl -sf https://lmu.lge.com/ExternalService/onscreencontrol/mac/2.0/OnScreenControlLatestVersion.txt)
    appNewVersion=$(echo $downloadFile | grep -o '[0-9].[0-9][0-9]')
    downloadURL="https://lmu.lge.com/ExternalService/onscreencontrol/mac/2.0/${downloadFile}"
    expectedTeamID="5SKT5H4CPQ"
    ;;
