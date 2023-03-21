audacity)
    name="Audacity"
    type="dmg"
    archiveName="audacity-macOS-[0-9.]*-universal.dmg"
    downloadURL=$(downloadURLFromGit audacity audacity)
    appNewVersion=$(versionFromGit audacity audacity)
    expectedTeamID="AWEYX923UX"
    ;;
