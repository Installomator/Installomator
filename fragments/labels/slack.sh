slack)
    name="Slack"
    type="dmg"
    downloadURL="https://slack.com/ssb/download-osx-universal" # Universal
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | tr -d '\r\n' | sed -E 's/.*macos\/([0-9.]*)\/.*/\1/g' )
    expectedTeamID="BQR82RBBHL"
    ;;
