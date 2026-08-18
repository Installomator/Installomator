glean)
    name="Glean"
    type="dmg"
    appNewVersion=$(curl -sL "https://storage.googleapis.com/glean-downloads/glean-desktop-app/latest-mac.yml" | grep "^version:" | sed 's/^version:[[:space:]]*\([0-9.]*\).*/\1/')
    downloadURL="https://storage.googleapis.com/glean-downloads/glean-desktop-app/Glean-${appNewVersion}-universal.dmg"
    expectedTeamID="877XN49FUQ"
    ;;
