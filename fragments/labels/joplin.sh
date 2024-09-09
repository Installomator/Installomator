joplin)
	# An offline-first, open-source note-taking and to-do app that supports Markdown, offers end-to-end encrypted sync, and is available across multiple platforms
    name="Joplin"
    type="dmg"
	if [[ $(arch) == "arm64" ]]; then
      printlog "Architecture: arm64"
      archiveName="Joplin-[0-9.]*-arm64.DMG"
    elif [[ $(arch) == "i386" ]]; then
      printlog "Architecture: i386"
      archiveName="Joplin-[0-9.]*.dmg"
    fi
    downloadURL="$(downloadURLFromGit laurent22 joplin)"
    appNewVersion="$(versionFromGit laurent22 joplin)"
    expectedTeamID="A9BXAFS6CT"
    ;;