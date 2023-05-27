dialpad)
    # credit: @ehosaka
    name="Dialpad"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://storage.googleapis.com/dialpad_native/osx/arm64/Dialpad.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://storage.googleapis.com/dialpad_native/osx/x64/Dialpad.dmg"
    fi
    expectedTeamID="9V29MQSZ9M"
    ;;
