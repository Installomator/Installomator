panopto)
    name="Panopto"
    type="pkg"
    if [[ -z $panoptoServer ]]; then
        cleanupAndExit 89 "This label requires more parameters: panoptoServer=hostname, this will ensure the downloaded version is both current and supports your server." ERROR
    fi
    downloadURL="http://$panoptoServer/$(curl -Ls http://$panoptoServer/ | grep cacheRoot | cut -d "'" -f 2 | awk -F '\\' '{ printf  $4 $5 $6 }' | awk -F 'x2f' '{ printf $2 "/" $3 "/" $4 }')/Software/Panopto%20Recorder.pkg?arch=None&useCustomBinary=True"
    # while there is version information in the URL, it rarely directly matches the client that gets downloaded.
    # need to create a service account createAccount -username panopto_upload -realname panopto_upload -home /var/panopto -shell /sbin/nologin -hiddenUser
    expectedTeamID="G7FR783UED"
    ;;
