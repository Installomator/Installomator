gotomeeting|\
gotowebinar)
    name="GoTo"
    type="dmg"
    gotoFeed=$(curl -fsL "https://goto-desktop.goto.com/latest-mac.yml" | tr -d '\r')
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://goto-desktop.goto.com/$(echo "$gotoFeed" | awk '/url: .*-arm64\.dmg$/ {print $3}' | head -1)"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://goto-desktop.goto.com/$(echo "$gotoFeed" | awk '/url: .*\.dmg$/ && !/arm64/ {print $3}' | head -1)"
    fi
    appNewVersion=$(echo "$gotoFeed" | awk '/^version:/ {print $2}')
    expectedTeamID="GFNFVT632V"
    ;;
