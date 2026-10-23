otter)
    name="Otter"
    type="pkg"
    otterFeedURL="https://assets.otter.ai/desktop-app/mac/production/production-mac.yml"
    otterFeed="$(curl -fsL "$otterFeedURL")"
    appNewVersion="$(echo "$otterFeed" | awk -F': ' '/^version:/{print $2; exit}')"
    otterFile="$(echo "$otterFeed" | awk -F': ' '/^path:/{print $2; exit}')"
    downloadURL="https://assets.otter.ai/desktop-app/mac/production/${otterFile%.zip}.pkg"
    expectedTeamID="6AWUP5FE76"
    ;;
