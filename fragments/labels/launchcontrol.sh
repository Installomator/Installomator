launchcontrol)
    name="LaunchControl"
    type="tbz"
    appNewVersion="$(curl -fsL https://www.soma-zone.com/download | grep -oE 'files/LaunchControl-[0-9]+\.[0-9]+(\.[0-9]+)?\.tar\.xz' | sed -E 's/files\/LaunchControl-([0-9.]+)\.tar\.xz/\1/' | head -n 1)"
    downloadURL="https://www.soma-zone.com/download/files/LaunchControl-${appNewVersion}.tar.xz"
    expectedTeamID="H665B6EEXC"
    ;;
