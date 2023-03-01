panopto)
    name="Panopto"
    type="pkg"
    if [ -z $panoptoServer ]; then
        cleanupAndExit 89 "This label requires more parameters: panoptoServer=host.name.panopto.com, this will ensure the downloaded version is both current and supports your server." ERROR
    fi
    downloadURL="http://$panoptoServer/$(curl -Ls http://$panoptoServer/ | grep cacheRoot | cut -d "'" -f 2 | awk -F '\\' '{ printf  $4 $5 $6 }' | awk -F 'x2f' '{ printf $2 "/" $3 "/" $4 }')/Software/Panopto%20Recorder.pkg?arch=None&useCustomBinary=True"
    # not setting packageID as the version will never match (i.e. 13.0.0.12345), while appNewVersion matches CFBundleShortVersionString (i.e. 13.0.0)
    appNewVersion=$(curl -s "$downloadURL" | grep "Object moved to" | sed -e 's/.*Version\=\mac\%2f\(.*\)\&amp\;server.*/\1/')
    expectedTeamID="G7FR783UED"
    ;;
