onscreencontrol)
    name="OnScreen Control"
    type="pkgInZip"
    packageID="com.LGSI.OnScreen-Control"
    downloadURL=$(currentFileName=`curl -s https://lmu.lge.com/ExternalService/onscreencontrol/mac/2.0/OnScreenControlLatestVersion.txt` && echo https://lmu.lge.com/ExternalService/onscreencontrol/mac/2.0/"$currentFileName")
    appNewVersion=$(curl -s https://lmu.lge.com/ExternalService/onscreencontrol/mac/2.0/OnScreenControlLatestVersion.txt | sed -E 's/.*_([0-9.]*)\.zip/\1/g')
    expectedTeamID="5SKT5H4CPQ"
    ;;
