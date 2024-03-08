hoppscotch)
    name="Hoppscotch"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        archiveName="Hoppscotch_mac_aarch64.dmg"
    elif [[ $(arch) == i386 ]]; then
        archiveName="Hoppscotch_mac_x64.dmg" 
    fi
    downloadURL="$(downloadURLFromGit hoppscotch releases)"
    appNewVersion="$(versionFromGit hoppscotch releases)"
    expectedTeamID="XBK86CMQGZ"
    ;;
