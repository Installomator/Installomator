dialpad)
    name="Dialpad"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.dialpad.com/osx/arm64/Dialpad.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.dialpad.com/osx/x64/Dialpad.dmg"
    fi
    expectedTeamID="9V29MQSZ9M"
    ;;
