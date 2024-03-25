bruno)
    # https://github.com/usebruno/bruno; https://www.usebruno.com/
    name="Bruno"
    type="dmg"
    if [[ $(arch) == “arm64” ]]; then
        archiveName="bruno_[0-9.]*_arm64_mac.dmg"
    elif [[ $(arch) == “i386” ]]; then
        archiveName="bruno_[0-9.]*_x64_mac.dmg"
    fi
    downloadURL="$(downloadURLFromGit usebruno bruno)"
    appNewVersion="$(versionFromGit usebruno bruno)"
    expectedTeamID="W7LPPWA48L"
    ;;
