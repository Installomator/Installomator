slack)
    name="Slack"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
       downloadURL="https://slack.com/ssb/download-osx"
    elif [[ $(arch) == arm64 ]]; then
       downloadURL="https://slack.com/ssb/download-osx-silicon"
    fi
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | cut -d "/" -f6 )
    expectedTeamID="BQR82RBBHL"
    ;;
