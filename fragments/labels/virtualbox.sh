virtualbox)
    name="VirtualBox"
    type="pkgInDmg"
    pkgName="VirtualBox.pkg"
    if [[ $(arch) == "arm64" ]]; then
        virtualboxPlatform="DARWIN_ARM64_GENERIC"
    elif [[ $(arch) == "i386" ]]; then
        virtualboxPlatform="DARWIN_64BITS_GENERIC"
    fi
    virtualboxFeed=$(curl -fsL "https://update.virtualbox.org/query.php/?platform=${virtualboxPlatform}&version=7.0.00_000000&branch=stable")
    downloadURL=$(echo "$virtualboxFeed" | awk '{print $2}')
    appNewVersion=$(echo "$virtualboxFeed" | awk '{print $1}')
    expectedTeamID="VB5E2TV963"
    blockingProcesses=( VirtualBox VirtualBoxVM VBoxHeadless )
    ;;
