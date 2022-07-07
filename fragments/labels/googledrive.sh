googledrive|\
googledrivefilestream)
    # credit: Eddie Vartanessian (@eddiev2)
    name="GoogleDrive"
    type="pkgInDmg"
    if [[ $(arch) == "i386" ]]; then
    packageID="com.google.drivefs.x86_64"
    fi

    if [[ $(arch) == "arm*" ]]; then
    packageID="com.google.drivefs.arm64"
    fi
    downloadURL="https://dl.google.com/drive-file-stream/GoogleDrive.dmg"
    #appNewVersion=$(curl -fs https://support.google.com/a/answer/7577057\?hl\=en | grep "Version " | sed '1p;d;/Version /!d' | awk -F' ' '{print $5}' | cut -b 1-4)
    expectedTeamID="EQHXZ8M8AV"
    ;;
