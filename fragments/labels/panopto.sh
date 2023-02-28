panopto)
    name="Panopto"
    type="pkg"
    if [[ -z $panoptoServer ]]; then
        cleanupAndExit 89 "This label requires more parameters: panoptoServer=host.name.panopto.com, this will ensure the downloaded version is both current and supports your server." ERROR
    elif [[ "$(dscl . read /Users/panopto_upload 2>&1 | grep -c eDSRecordNotFound)" -gt 0 ]]; then
    # The installer pkg will try to create this account without permission and fail, or ask the user to create it.
    # However, the installer pkg will detect if the account has already been created, and use it,
    #    so manually creating it stops the installer from bothering the user or failing.
        sysadminctl -addUser panopto_upload -fullName panopto_upload -home /private/var/panopto -shell /sbin/nologin
        sleep 1
        dscl . create /Users/panopto_upload dsAttrTypeNative:IsHidden 1
    fi
    downloadURL="http://$panoptoServer/$(curl -Ls http://$panoptoServer/ | grep cacheRoot | cut -d "'" -f 2 | awk -F '\\' '{ printf  $4 $5 $6 }' | awk -F 'x2f' '{ printf $2 "/" $3 "/" $4 }')/Software/Panopto%20Recorder.pkg?arch=None&useCustomBinary=True"
    # While there is version information in the URL, it rarely directly matches the client that gets downloaded (major version only).
    expectedTeamID="G7FR783UED"
    ;;
