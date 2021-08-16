keepassxc)
    name="KeePassXC"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
      archiveName="x86_64.dmg"
    elif [[ $(arch) == arm64 ]]; then
      archiveName="arm64.dmg"
    fi
    downloadURL=$(downloadURLFromGit keepassxreboot keepassxc)
    appNewVersion=$(versionFromGit keepassxreboot keepassxc)
    expectedTeamID="G2S7P7J672"
    ;;
