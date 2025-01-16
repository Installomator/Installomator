launchcontrol)
    name="LaunchControl"
    type="tbz"
    appNewVersion="$(curl -Ls https://www.soma-zone.com/download/files/ | grep -o 'LaunchControl-[0-9]*\.[0-9]*\.[0-9]*\.tar\.xz' | sed -E 's/LaunchControl-([0-9]*\.[0-9]*\.[0-9]*)\.tar\.xz/\1/' | sort -V | tail -n 1)"
	downloadURL="https://www.soma-zone.com/download/files/LaunchControl-$appNewVersion.tar.xz"
    expectedTeamID="H665B6EEXC"
    ;;
