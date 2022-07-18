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
    #appNewVersion=$(curl -fs https://support.google.com/a/answer/7577057\?hl\=en |  grep -o "Version [0-9][0-9]" | sed '1p;d;/Version /!d')
    expectedTeamID="EQHXZ8M8AV"
    ;;
