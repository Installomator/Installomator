panopto)
    name="Panopto"
    type="pkg"
    if [ "$(who | grep console | cut -d ' ' -f 1)" = "_mbsetupuser" ] || [ -z "$(fdesetup list)" ]; then
        cleanupAndExit 89 "This label cannot be installed when there are no user attached Secure Tokens, such as during a DEP/ASM/ABM enrolment into an MDM, as the package requires adding an account that could in-advertantly steal the first Token." ERROR
    elif [ -z $panoptoServer ]; then
        cleanupAndExit 89 "This label requires more parameters: panoptoServer=host.name.panopto.com, this will ensure the downloaded version is both current and supports your server." ERROR
    fi
    # The installer pkg will try to create this account and fail when it attempts to update the
    #   NFSHomeDirectory (or it triggers a request for permission from the user).
    # However, the installer pkg will detect if the account has already been created, and use it,
    #   so manually creating it stops the installer from bothering the user or failing.
    # The following is based on what the package does, but should handle it with the permission required.
    panoptoUser="panopto_upload"
    panoptoPath="/Users/$panoptoUser"
    if [ "$(dscl . -read $panoptoPath NFSHomeDirectory 2>&1 | grep -c "No such key")" -gt 0 ]; then
        sysadminctl -deleteUser $panoptoUser
    fi
    if [ "$(dscl . read $panoptoPath 2>&1 | grep -c eDSRecordNotFound)" -gt 0 ]; then
        for ((new_uid = 401; new_uid < 500; new_uid++)); do
            if [ "$(dscl . -search /Users UniqueID $new_uid | wc -l)" -eq 0 ]; then
                break  
            fi
        done
        sysadminctl -addUser $panoptoUser -fullName $panoptoUser -home /private/var/panopto -shell /sbin/nologin -UID $new_uid -GID 1
        dscl . create $panoptoPath this_password_is_disabled
        dscl . create $panoptoPath dsAttrTypeNative:IsHidden 1
    # The package does do more, however the above covers what is skipped by mk_hidden_user.sh when
    #   the account already exists. Installomator may still require Full Disk Access, but should
    #   inherit that permission from the calling process, which doesn't happen for mk_hidden_user.sh.
    fi
    downloadURL="http://$panoptoServer/$(curl -Ls http://$panoptoServer/ | grep cacheRoot | cut -d "'" -f 2 | awk -F '\\' '{ printf  $4 $5 $6 }' | awk -F 'x2f' '{ printf $2 "/" $3 "/" $4 }')/Software/Panopto%20Recorder.pkg?arch=None&useCustomBinary=True"
    # not setting packageID as the version will never match (i.e. 13.0.0.12345), while appNewVersion matches CFBundleShortVersionString (i.e. 13.0.0)
    appNewVersion=$(curl -s "$downloadURL" | grep "Object moved to" | sed -e 's/.*Version\=\mac\%2f\(.*\)\&amp\;server.*/\1/')
    expectedTeamID="G7FR783UED"
    ;;
