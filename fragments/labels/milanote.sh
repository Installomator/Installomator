milanote)
    name="Milanote"
    type="dmg"
    appNewVersion=$(curl -fsSL "https://milanote-app-releases.s3.amazonaws.com/latest-mac.yml" | awk '/^version:/ {print $2; exit}')
    downloadURL="https://milanote-app-releases.s3.amazonaws.com/Milanote-${appNewVersion}.dmg"
    expectedTeamID="9T9DP69Z4A"
    ;;
