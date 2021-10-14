slack)
    name="Slack"
    type="dmg"
    downloadURL="https://slack.com/ssb/download-osx-universal" # Universal
#    if [[ $(arch) == "arm64" ]]; then
#        downloadURL="https://slack.com/ssb/download-osx-silicon"
#    elif [[ $(arch) == "i386" ]]; then
#        downloadURL="https://slack.com/ssb/download-osx"
#    fi
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | tr -d '
' | sed -E 's/.*macos\/([0-9.]*)\/.*/\1/g' )
    expectedTeamID="BQR82RBBHL"
    ;;
