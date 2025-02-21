slack)
    name="Slack"
    type="dmg"
    downloadURL="https://slack.com/ssb/download-osx-universal"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | cut -d "/" -f7 )
    expectedTeamID="BQR82RBBHL"
    ;;
