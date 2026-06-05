termius)
    name="Termius"
    type="dmg"
    downloadURL="https://termi.us/mac-download"
    appNewVersion=$(curl -fsL "https://autoupdate.termius.com/mac-universal/latest-mac.yml" | awk '/^version:/{print $2; exit}')
    expectedTeamID="6KN952WR85"
    ;;
