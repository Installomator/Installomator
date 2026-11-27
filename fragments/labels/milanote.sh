milanote)
    name="Milanote"
    type="dmg"
    milanoteFilename=$(curl -fsSL "https://milanote-app-releases.s3.amazonaws.com/latest-mac.yml" | awk '/^path:/ {print $2; exit}')
    appNewVersion=$(curl -fsSL "https://milanote-app-releases.s3.amazonaws.com/latest-mac.yml" | awk '/^version:/ {print $2; exit}')
    downloadURL="https://milanote-app-releases.s3.amazonaws.com/{milanoteFilename}.dmg"
    expectedTeamID="9T9DP69Z4A"
    ;;
