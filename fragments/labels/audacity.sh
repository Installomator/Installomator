audacity)
    name="Audacity"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
      archiveName="audacity-macOS-[0-9.]*-arm64.dmg"
      downloadURL=$(downloadURLFromGit audacity audacity)
    elif [[ $(arch) == "i386" ]]; then
      archiveName="audacity-macOS-[0-9.]*-x86_64.dmg"
      downloadURL=$(downloadURLFromGit audacity audacity)
    fi
    appNewVersion=$(versionFromGit audacity audacity)
    expectedTeamID="AWEYX923UX"
    ;;
