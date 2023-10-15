audacity)
    name="Audacity"
    type="dmg"
    archiveName="audacity-macOS-[0-9.]*-universal.dmg"
    downloadURL=$(downloadURLFromGit audacity audacity)
    appNewVersion=$(versionFromGit audacity audacity)
    appCustomVersion(){ defaults read "/Applications/Audacity.app/Contents/Info.plist" CFBundleVersion | cut -d '.' -f 1-3 }
    expectedTeamID="AWEYX923UX"
    ;;
