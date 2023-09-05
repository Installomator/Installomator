zulip)
    name="Zulip"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
        downloadURL="https://zulip.com/apps/download/mac"
    elif [[ $(arch) == arm64 ]]; then
        downloadURL="https://zulip.com/apps/download/mac-arm64"
    fi
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i ^location | sed 's/.*\/v\(.*\)\/Zulip-.*/\1/')
    expectedTeamID="66KHCWMEYB"
    ;;
