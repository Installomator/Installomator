buzz)
    name="Buzz"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="mac-ARM64.dmg"
    else
        archiveName="mac-X64.dmg"
    fi
    downloadURL=$(downloadURLFromGit "chidiwilliams" "buzz")
    appNewVersion=$(versionFromGit "chidiwilliams" "buzz")
    expectedTeamID="G2V69FA555"
    ;;
