slack)
    name="Slack"
    type="pkg"
    downloadURL="https://slack.com/api/desktop.latestRelease?redirect=1&variant=pkg&arch=universal"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | cut -d "/" -f7 )
    expectedTeamID="BQR82RBBHL"
    ;;
