glean)
    name="Glean"
    type="pkg"
    appNewVersion=$(curl -fsL "https://storage.googleapis.com/glean-downloads/glean-desktop-app/latest-mac.yml" | awk -F': ' '/^version:/{print $2; exit}')
    downloadURL="https://storage.googleapis.com/glean-downloads/glean-desktop-app/Glean-${appNewVersion}-universal.pkg"
    expectedTeamID="877XN49FUQ"
    ;;
