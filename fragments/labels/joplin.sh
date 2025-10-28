joplin)
    name="Joplin"
    type="dmg"
	if [[ $(arch) == “arm64” ]]; then
        archiveName="Joplin-[0-9.]*-arm64.DMG"
    elif [[ $(arch) == “i386” ]]; then
        archiveName="Joplin-[0-9.]*.dmg"
    fi
    downloadURL="$(downloadURLFromGit laurent22 joplin)"
    appNewVersion="$(versionFromGit laurent22 joplin)"
    expectedTeamID="A9BXAFS6CT"
    ;;
