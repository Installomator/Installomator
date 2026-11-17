dialpad)
    name="Dialpad"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.dialpad.com/osx/arm64/Dialpad.dmg"
        dialpadVersionURL="https://dialpad.com/native/minsupportedversion/darwin/arm64/?channel=stable"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.dialpad.com/osx/x64/Dialpad.dmg"
        dialpadVersionURL="https://dialpad.com/native/minsupportedversion/darwin/x64/?channel=stable"
    fi
    appNewVersion=$(getJSONValue "$(curl -fsL "$dialpadVersionURL")" latest_version)
    expectedTeamID="9V29MQSZ9M"
    ;;
