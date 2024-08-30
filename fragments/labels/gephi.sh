gephi)
	# An open-source software that visualizes and manipulates large graphs with ease, featuring a user-friendly interface and powerful real-time capabilities
    name="Gephi"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        archiveName="gephi-[0-9.]*-macos-aarch64.dmg"
    elif [[ $(arch) == i386 ]]; then
        archiveName="gephi-[0-9.]*-macos-x64.dmg"
    fi
    appNewVersion="$(versionFromGit gephi gephi)"
    downloadURL="$(downloadURLFromGit gephi gephi)"
    expectedTeamID="3D8H75J8UL"
    ;;
