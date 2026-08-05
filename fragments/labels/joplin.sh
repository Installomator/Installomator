joplin)
    name="Joplin"
    type="dmg"
    if [[ "$arch" == "arm64" ]]; then
        archiveName="arm64.DMG"
    elif [[ "$arch" == "i386" ]]; then
        archiveName=".dmg"
    fi
    downloadURL=$(downloadURLFromGit laurent22 joplin)
    appNewVersion=$(versionFromGit laurent22 joplin)
    expectedTeamID="A9BXAFS6CT"
    ;;
