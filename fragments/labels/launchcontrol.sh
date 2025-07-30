launchcontrol)
	# A macOS GUI application for managing and configuring system services and launch daemons
    name="LaunchControl"
    type="tbz"
    appNewVersion="$(curl -Ls https://www.soma-zone.com/download/files/ | grep -oE 'LaunchControl-[0-9]+\.[0-9]+(\.[0-9]+)?\.tar\.xz' | grep -vE 'DP|_update' | sed -E 's/LaunchControl-([0-9]+\.[0-9]+(\.[0-9]+)?)\.tar\.xz/\1/' | sort -V | tail -n 1)"
	downloadURL="https://www.soma-zone.com/download/files/LaunchControl-$appNewVersion.tar.xz"
    expectedTeamID="H665B6EEXC"
    ;;
