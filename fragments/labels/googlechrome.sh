googlechrome)
    name="Google Chrome"
    type="dmg"
    downloadURL="https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg"
    # omahaproxy is permanently dead; so we need to use the google api service now
    if [[ $(arch) == "arm64" ]]; then
    # we pick the second name because the first is a limited rollout; the secon name is the wider distributed package
        appNewVersion=$(curl -s https://versionhistory.googleapis.com/v1/chrome/platforms/mac_arm64/channels/stable/versions | grep name | head -n 1 | tail -n 1 | cut -d \" -f 4 | cut -d / -f 7)
    elif [[ $(arch) == "i386" ]]; then
    # we pick the second name because the first is a limited rollout; the secon name is the wider distributed package
        appNewVersion=$(curl -s https://versionhistory.googleapis.com/v1/chrome/platforms/mac/channels/stable/versions | grep name | head -n 1 | tail -n 1 | cut -d \" -f 4 | cut -d / -f 7)
    fi
    expectedTeamID="EQHXZ8M8AV"
    printlog "WARNING for ERROR: Label googlechrome should not be used. Instead use googlechromepkg as per recommendations from Google. It's not fully certain that the app actually gets updated here. googlechromepkg will have built in updates and make sure the client is updated in the future." REQ
    ;;
