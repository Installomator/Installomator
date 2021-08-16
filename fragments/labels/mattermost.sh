mattermost)
    name="Mattermost"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
      archiveName="mac.dmg"
    elif [[ $(arch) == arm64 ]]; then
      archiveName="mac-m1.dmg"
    fi
    downloadURL=$(downloadURLFromGit mattermost desktop)
    appNewVersion=$(versionFromGit mattermost desktop )
    expectedTeamID="UQ8HT4Q2XM"
    ;;
