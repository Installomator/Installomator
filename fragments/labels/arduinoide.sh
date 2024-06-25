arduinoide)
    name="Arduino IDE"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="arduino-ide_[0-9.]*_macOS_arm64.dmg"

    elif [[ $(arch) == "i386" ]]; then
        archiveName="arduino-ide_[0-9.]*_macOS_64bit.dmg"
    fi
    downloadURL="$(downloadURLFromGit arduino arduino-ide)"
    appNewVersion="$(versionFromGit arduino arduino-ide)"
    expectedTeamID="7KT7ZWMCJT"
    ;;

